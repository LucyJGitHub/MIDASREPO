     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Account Transfer Update T_GZAMADEX')
      *****************************************************************
      *                                                               *
      *  Midas Plus - Global Processing Module                        *
      *                                                               *
      *  GP000043 - Midas GP Account Transfer Update T_GZAMADEX       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR719317*CREATE  Date 19Jul11                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR719317 - Include T_GZAMADEX in ATU processing              *
      *                                                               *
      *****************************************************************
      *
     FGPAUTFPD  O    E           K DISK    INFSR(*PSSR)
      *
     D/COPY GPCPYSRCG,STD_D_SPEC
      *
      ** Define SQL UPDATE statement.
      *
     D @RUN            S              1
     D PZONE           S             10A
     D PREF            S             10A
     D P@FRAC          S             24A
     D P@TOAC          S             24A
     D DSFCNU          S              6A
     D DSFCCY          S              3A
     D DSFACO          S             10A
     D DSFACS          S              2A
     D DSFBRC          S              3A
     D DSTCNU          S              6A
     D DSTCCY          S              3A
     D DSTACO          S             10A
     D DSTACS          S              2A
     D DSTBRC          S              3A
     D DSFCNU2         S             10A
     D DSTCNU2         S             10A
     D STMT1           S            500A   INZ('UPDATE T_GZAMADEX SET +
     D                                     DDBRCA =      , DDCUSN +
     D                                     =             , DDCCY +
     D                                     =      , DDACOD +
     D                                     =             , DDACSQ +
     D                                     =      WHERE +
     D                                     DDBRCA =       AND DDCUSN +
     D                                     =              AND DDCCY +
     D                                     =       AND DDACOD +
     D                                     =              AND DDACSQ +
     D                                     =      AND ZONE +
     D                                     =             ')
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PZONE
     C                   PARM                    PREF
     C                   PARM                    P@FRAC
     C                   PARM                    P@TOAC
      *
      ** Retrieve account details
      *
     C                   EVAL      DSFCNU = %SUBST(P@FRAC:1:6)
     C                   EVAL      DSFCCY = %SUBST(P@FRAC:7:3)
     C                   EVAL      DSFACO = %SUBST(P@FRAC:10:10)
     C                   EVAL      DSFACS = %SUBST(P@FRAC:20:2)
     C                   EVAL      DSFBRC = %SUBST(P@FRAC:22:3)
     C                   EVAL      DSTCNU = %SUBST(P@TOAC:1:6)
     C                   EVAL      DSTCCY = %SUBST(P@TOAC:7:3)
     C                   EVAL      DSTACO = %SUBST(P@TOAC:10:10)
     C                   EVAL      DSTACS = %SUBST(P@TOAC:20:2)
     C                   EVAL      DSTBRC = %SUBST(P@TOAC:22:3)
     C                   EVAL      DSFCNU2 = '   -'
     C                   MOVEL     DSFBRC        DSFCNU2
     C                   MOVE      DSFCNU        DSFCNU2
     C                   EVAL      DSTCNU2 = '   -'
     C                   MOVEL     DSTBRC        DSTCNU2
     C                   MOVE      DSTCNU        DSTCNU2
      *
      ** Calculate SQL UPDATE statement.
      *
     C                   EVAL      %SUBST(STMT1:32:1) = ''''
     C                   EVAL      %SUBST(STMT1:33:3) = DSTBRC
     C                   EVAL      %SUBST(STMT1:36:1) = ''''
     C                   EVAL      %SUBST(STMT1:48:1) = ''''
     C                   EVAL      %SUBST(STMT1:49:10) = DSTCNU2
     C                   EVAL      %SUBST(STMT1:59:1) = ''''
     C                   EVAL      %SUBST(STMT1:70:1) = ''''
     C                   EVAL      %SUBST(STMT1:71:3) = DSTCCY
     C                   EVAL      %SUBST(STMT1:74:1) = ''''
     C                   EVAL      %SUBST(STMT1:86:1) = ''''
     C                   EVAL      %SUBST(STMT1:87:10) = DSTACO
     C                   EVAL      %SUBST(STMT1:97:1) = ''''
     C                   EVAL      %SUBST(STMT1:109:1) = ''''
     C                   EVAL      %SUBST(STMT1:110:2) = DSTACS
     C                   EVAL      %SUBST(STMT1:112:1) = ''''
     C                   EVAL      %SUBST(STMT1:129:1) = ''''
     C                   EVAL      %SUBST(STMT1:130:3) = DSFBRC
     C                   EVAL      %SUBST(STMT1:133:1) = ''''
     C                   EVAL      %SUBST(STMT1:148:1) = ''''
     C                   EVAL      %SUBST(STMT1:149:10) = DSFCNU2
     C                   EVAL      %SUBST(STMT1:159:1) = ''''
     C                   EVAL      %SUBST(STMT1:173:1) = ''''
     C                   EVAL      %SUBST(STMT1:174:3) = DSFCCY
     C                   EVAL      %SUBST(STMT1:177:1) = ''''
     C                   EVAL      %SUBST(STMT1:192:1) = ''''
     C                   EVAL      %SUBST(STMT1:193:10) = DSFACO
     C                   EVAL      %SUBST(STMT1:203:1) = ''''
     C                   EVAL      %SUBST(STMT1:218:1) = ''''
     C                   EVAL      %SUBST(STMT1:219:2) = DSFACS
     C                   EVAL      %SUBST(STMT1:221:1) = ''''
     C                   EVAL      %SUBST(STMT1:234:1) = ''''
     C                   EVAL      %SUBST(STMT1:235:10) = PZONE
     C                   EVAL      %SUBST(STMT1:245:1) = ''''
      *
      ** Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      **  Prepare STMT as initialised in declare section and
      **  modified in calculations
      *
     C/EXEC SQL
     C+    PREPARE S1 FROM :STMT1
     C/END-EXEC
      *
     C/EXEC SQL
     C+    EXECUTE S1
     C/END-EXEC
      *
     C                   IF        SQLCOD = 0
     C                   EVAL      GPZONE = PZONE
     C                   EVAL      GPREFN = PREF
     C                   EVAL      GPFILE = 'T_GZAMADEX'
     C                   EVAL      GPLFIL = *BLANKS
     C                   EVAL      GPFBRC = DSFBRC
     C                   EVAL      GPFCNU = DSFCNU
     C                   EVAL      GPFACO = DSFACO
     C                   EVAL      GPFACS = DSFACS
     C                   EVAL      GPTBRC = DSTBRC
     C                   EVAL      GPTCNU = DSTCNU
     C                   EVAL      GPTACO = DSTACO
     C                   EVAL      GPTACS = DSTACS
     C                   EVAL      GPTEXT = 'T_GZAMADEX'
     C                   EVAL      GPCRTD = *BLANKS
     C                   WRITE     GPAUTFD0
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
