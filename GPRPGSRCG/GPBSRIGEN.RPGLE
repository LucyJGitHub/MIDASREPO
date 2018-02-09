     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP BSPL Request ID Generation')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSRIGEN - BSPL Request ID Generation                       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPBSRIL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FGPBSRIPD  O  A E           K DISK    INFSR(*PSSR) RENAME(GPBSRID0:GPBSRIW)
 
 
 
 
      * Get next available number
 
     C                   EXSR      NEXT_AVAIL
 
 
     C                   RETURN
 
      /EJECT
      ****************************************************************
      * Get next available number
      ****************************************************************
     C     NEXT_AVAIL    BEGSR
 
      * ACCESS RECORD
 
     C     GPBSRIK       CHAIN     GPBSRID0                           99
 
      * WRITE RECORD IF NOT FOUND
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DDRQTYP       SCRQTYP
     C                   Z-ADD     1             SCNRQID
     C                   WRITE     GPBSRIW
     C     GPBSRIK       CHAIN     GPBSRID0                           99
     C                   END
 
      * PASS BACK NEXT AVAILABLE NUMBER
 
     C                   MOVEL     SCNRQID       DDRQID
 
      * UPDATE NEXT REQUEST ID
 
     C                   ADD       1             SCNRQID
 
      * UPDATE RECORD
 
     C                   UPDATE    GPBSRID0
      *
     C                   ENDSR
     C****************************************************************
      /SPACE 5
      *******************************************************************
      * *INZSR - Initial Processing
      *******************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * BSPL Request Type
 
     C                   PARM                    DDRQTYP           1
 
      * BSPL Request ID
 
     C                   PARM                    DDRQID           15
 
      * Key lists
 
     C     GPBSRIK       KLIST
     C                   KFLD                    DDRQTYP
 
     C                   ENDSR
      **********************************************************************************
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
