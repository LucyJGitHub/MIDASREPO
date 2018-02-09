     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Country Details Trigger Program')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGPCTRYPD - On-Line Update of Global File T_GPUTILSR        *
      *             - Trigger program for GPCTRYPD                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG4521 *CREATE    Date 14Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG4521- Update file T_GPUTILSR                              *
      *                                                               *
      *****************************************************************
 
O    FGPUTILL0  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
O
O    D G_GPCTRYPD    E DS                  EXTNAME(GPCTRYPD)
 
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
O    C                   MOVEL     I#BIMG        G_GPCTRYPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        G_GPCTRYPD
O    C                   ENDIF
O
     C     I#BFAF        IFEQ      *BLANKS
     C     I#BIMG        ANDEQ     *BLANKS
     C** INSERT
     C                   EXSR      GPCTRY
O    C                   WRITE     T_GPUTILSR
     C                   ELSE
      * Use A4CNCD from GPCTRYPD to get position on GPUTILL0
     C
     C                   Z-ADD     FILETYPE      KTYPE
     C                   MOVEL     A4CNCD        KCODE
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
 
     C                   EXSR      GPCTRY
 
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
      * GPCTRY - Set up fields
      ********************************************************************
     C     GPCTRY        BEGSR
O
      * Move GPCTRYPD fields into layout for T_GPUTILSR
      * Type
     C                   EVAL      UTSRTYPE = FILETYPE
      * Code
     C                   EVAL      UTSRCODE = A4CNCD
      * Name
     C                   EVAL      UTSRNAME = A4CNNM
      * Status
     C                   IF        A4CHTP = 'D'
     C                   EVAL      UTSRACTIVE = 'N'
     C                   ELSE
     C                   EVAL      UTSRACTIVE = 'Y'
     C                   ENDIF
 
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
     C                   Z-ADD     3             FILETYPE
 
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
