     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas extract SEMVTSPD record for MT544-7')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management                                   *
      *                                                               *
      *  MG54XTRD  - Add record in SEMVTTPD                           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE039  *CREATE    Date 05Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE039 - MT544-7 Message generation.                         *
      *                                                               *
      *****************************************************************
     FSEMVTTPD  O  A E             DISK    INFSR(*PSSR)
     FSEMVTDPD  O  A E             DISK    INFSR(*PSSR)
     FSEMVTVPD  O  A E             DISK    INFSR(*PSSR)
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7         File controls out of balance                    *
      *    U7, U8     Database in error                               *
      *    LR         Last record indicator                           *
      *                                                               *
      *****************************************************************
      *
     D NEW           E DS                  EXTNAME(SEMVTSPD)
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    NEW
      *
     C                   MOVEL     ' '           q@snddata
      *
     C     q@snddtaq     PLIST
     C                   PARM      'MSSETCONF'   q@dtaq           10
     C                   PARM      '*LIBL'       q@libl           10
     C                   PARM      1             q@length          5 0
     C                   PARM                    q@snddata        10
      *
     C     TMTRTY        IFEQ      'T'
     C                   WRITE     SEMVTTD0
     C                   MOVEL     'R'           q@snddata
     C                   call      'QSNDDTAQ'    q@SndDtaq
     C                   END
     C     TMTRTY        IFEQ      'D'
     C                   WRITE     SEMVTDD0
     C                   MOVEL     'R'           q@snddata
     C                   call      'QSNDDTAQ'    q@SndDtaq
     C                   END
     C     TMTRTY        IFEQ      'V'
     C                   WRITE     SEMVTVD0
     C                   MOVEL     'R'           q@snddata
     C                   call      'QSNDDTAQ'    q@SndDtaq
     C                   END
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
      *
     C                   DUMP
      *
      * Exit program
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
