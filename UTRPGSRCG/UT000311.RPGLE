     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*XBI *  OVRDBF FILE(UTC00311FB) TOFILE(UPOBJDTPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Source object cross check')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000311 - Manipulate DSPOBJD outfile for src/obj x-ref      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      *  Last Amend No. BUG27989           Date 08Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CUT011  *CREATE    Date 12Dec07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27989 - HATS should run with/without LDAP                 *
      *  CUT011 - Rewrite of command.  Make it more flexible and      *
      *           easier to maintain.                                 *
      *                                                               *
      *****************************************************************
     FUTC00311FBUF   E             DISK
      /EJECT
      *
     D ObjType         S              7
     D Recursive       S              1
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      * Read UTC00311FB file to check if source is present.
     C     1             SETLL     UTC00311FB
     C                   READ      UTC00311FB
      *
     C                   DOW       NOT(%EOF)
      *
      * Save object type in spare field.
     C                   EVAL      ODCRTS = ODOBTP
     C                   EVAL      ODOBTP = *blanks
      *
      * Perform checks to change object types.
     C                   IF        ODCRTS = '*FILE' or
     C                             ODCRTS = '*MODULE'
     C                   EVAL      ODOBTP = ODOBAT
     C                   ENDIF
      *
     C                   IF        ODCRTS = '*CMD'    or
     C                             ODCRTS = '*PNLGRP' or
     C                             ODCRTS = '*DTAARA' or
     C                             ODCRTS = '*SRVPGM' or
     C                             ODCRTS = '*BNDDIR' or
     C                             ODCRTS = '*TBL'    or
     C                             ODCRTS = '*VLDL'   or                                    BUG27989
     C                             ODCRTS = '*DTAQ'
     C                   EVAL      ObjType = %SUBST(ODCRTS:2:7)
     C                   EVAL      ODOBTP = ObjType
     C                   ENDIF
      *
     C                   IF        ODCRTS = '*PGM'
     C                   IF        %SUBST(ODSRCF:3:3) = 'PGM'
     C                   EVAL      ODOBTP = 'PGM'
     C                   ELSE
      *
     C                   IF        %SUBST(ODSRCF:3:3) = 'SQL'
     C                   EVAL      ODOBTP = 'SQLPROC'
     C                   ELSE
      *
     C                   EVAL      ODOBTP = ODOBAT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Update DSPOBJD outfile.
     C                   UPDATE    QLIDOBJD
      *
     C                   READ      UTC00311FB
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     Recursive     IFEQ      *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C     PSSREnd       ENDSR
      ********************************************************************
