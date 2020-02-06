     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Commitment Control Active?')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCMCTACT - Commitment Control Active?                       *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPELOGPD  O    E             DISK    INFSR(*PSSR) COMMIT USROPN
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ACTIVE          1
 
     C                   OPEN      GPELOGPD                             99
     C     *in99         IFEQ      *OFF
     C                   MOVEL     'Y'           I_ACTIVE
     C                   ENDIF
     C                   SETON                                        LR
     C                   RETURN
      /SPACE 5
      *****************************************************************
     C     *PSSR         BEGSR
     C     W#RUN         IFEQ      *BLANKS
     C                   MOVE      'Y'           W#RUN             1
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
