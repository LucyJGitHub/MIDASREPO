     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP RSACMTPD Replication Program (I/C)')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP003008 - Midas RSACMTPD Replication Program (I/C)          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD032098           Date 09Mar18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP203  *CREATE    Date 02Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032098 - Added GZRSACMTPD to commitment control.           *
      *           - Applied for MD-35969.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP203 - Teller Related APIs - Account Movements             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas GL Account Movements Files
     F***GZRSACMTPDO* A E           K DISK    INFSR(*PSSR)                                  MD032098
     FGZRSACMTPDO  A E           K DISK    INFSR(*PSSR) USROPN COMMIT(D_COM)                MD032098

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D G_RSACMTPD    E DS                  EXTNAME(GZRSACMTPD)

      ** +--------------------------------------+
      ** ¦  Declared variables                  ¦
      ** ¦  ==================                  ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D I#AIMG          S            172

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      * Global File Updates

     C                   WRITE     RSACMTPO

     C                   EVAL      *INLR = *ON

     C
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    G_RSACMTPD
      *                                                                                    MD0320980
      **Open for commit?                                                                   MD0320980
      *                                                                                    MD0320980
     C                   CALL      'GPCOPN4COM'                                            MD0320980
     C                   PARM                    D_COM             1                       MD0320980
     C                   OPEN      GZRSACMTPD                                              MD0320980

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   ENDIF

     C                   RETURN

     C                   ENDSR
      *****************************************************************
