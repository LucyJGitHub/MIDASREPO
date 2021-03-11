     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Update trailers files')                       *
      *****************************************************************
      *                                                               *
      *  Midas - LE Module                                            *
      *                                                               *
      *  LE007050  - Update Trailers                                  *
      *                                                               *
      *  Function:  This program reads INTSTZX, CONFSZX, LETLXZX      *
      ************* CUTX1ZX, MKEYZZ ***********************************                       263800
      *             CUTX1ZX, MKEYZZ, MATLNZX                          *                       263800
      *             restored from savf and updates nr of              *
      *             records on the DPLIB files                        *
      *                                                               *
      *  Called By: LEC0604N                                          *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 263800             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  263800 - Update MATLNZX too.                                 *
      *  CLE134 - Past Due Call Loans process                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Date Format                                     *
      *    U7+U8      Database Errors                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise Subroutine                                *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¾ F-specs                              ¾
      ** ¾ =======                              ¾
      ** +--------------------------------------+

     FCONFS     UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(LOAMSZ1F:CONFSTTF)
     F                                     IGNORE(LOAMSDKF)
     F                                     IGNORE(LOAMSDHF)
     FSINTS     UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(INTSTZXF:INTSSTTF)
     F                                     IGNORE(INTSTHHF)
     F                                     IGNORE(INTSTHNF)
     F                                     IGNORE(INTSTHPF)
     F                                     IGNORE(INTSTHQF)
     FSCUTX     UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(CUTX1ZXF:CUTX1TTF)
     F                                     IGNORE(CUTX1HHF)
     F                                     IGNORE(CUTX2HHF)
     F                                     IGNORE(CUTX1HNF)
     F                                     IGNORE(CUTX1HPF)
     F                                     IGNORE(CUTX1HQF)
     F                                     IGNORE(CUTX2HPF)
     F                                     IGNORE(CUTX2ZXF)
     FLETLX     UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(LOAMSZ1F:LETLXTTF)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSDKF)
     FMATLS     UF   E             DISK    INFSR(*PSSR) COMMIT                                263800
     F                                     RENAME(MATLNZXF:MATLNTTF)                          263800
     F                                     IGNORE(MATLNHHF)                                   263800
     F                                     IGNORE(MATLNMTF)                                   263800

     FLETLXZX   IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSZ1F:LETLXZXF)
     FCONFSZX   IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSZ1F:CONFSZXF)
     FCUTX1ZX   IF   E             DISK    INFSR(*PSSR)
     FINTSTZX   IF   E             DISK    INFSR(*PSSR)
     FMKEYZZ    IF   E             DISK    INFSR(*PSSR)
     FMATLNZX   IF   E             DISK    INFSR(*PSSR)                                       263800

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¾ D-specs                              ¾
      ** ¾ =======                              ¾
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      ** Defines:                           142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

     D RUNDAT        E DS                  EXTNAME(RUNDAT)

     D @RUN            S              1

      ** Additional Field Definitions

      *****************************************************************

      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¾                                                            ¾
      ** ¾ Initial processing is performed automatically: the *INZSR  ¾
      ** ¾ executed at program activation.                            ¾
      ** ¾                                                            ¾
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     *DTAARA       DEFINE                  LDA
     C     *LIKE         DEFINE    VLRF          WVLRF
     C     *LIKE         DEFINE    VLRL          WVLRL
     C     *LIKE         DEFINE    NORE          WNORE

      ** Access trailers

      ** CONFSZX

     C                   Z-ADD     0             WNORE
     C     0001          CHAIN     CONFSZX
     C                   IF        %FOUND
     C     NORE          SUB       2             WNORE
     C                   ENDIF
     C     WNORE         IFGT      0
     C     1             CHAIN     CONFS                              30
     C                   IF        %FOUND
     C                   ADD       WNORE         NORE
     C                   EXCEPT    CONFSO
     C                   ENDIF
     C                   ENDIF

      ** CUTX1ZX

     C                   Z-ADD     0             WNORE
     C     1             CHAIN     CUTX1ZX                            30
     C                   IF        %FOUND
     C     NORE          SUB       2             WNORE
     C                   ENDIF
     C     WNORE         IFGT      0
     C     0001          CHAIN     SCUTX
     C                   IF        %FOUND
     C                   ADD       WNORE         NORE
     C                   EXCEPT    CUTX1O
     C                   ENDIF
     C                   ENDIF

      ** LETLXZX

     C                   Z-ADD     0             WNORE
     C     1             CHAIN     LETLXZX                            30
     C                   IF        %FOUND
     C     NORE          SUB       2             WNORE
     C                   ENDIF
     C     WNORE         IFGT      0
     C     0001          CHAIN     LETLX
     C                   IF        %FOUND
     C**********         ADD       NORE          WNORE                                        263800
     C                   ADD       WNORE         NORE                                         263800
     C                   EXCEPT    LETLXO
     C                   ENDIF
     C                   ENDIF

      ** INTSTZX

     C                   Z-ADD     0             WNORE
     C     1             CHAIN     INTSTZX                            30
     C                   IF        %FOUND
     C     NORE          SUB       2             WNORE
     C                   ENDIF
     C     WNORE         IFGT      0
     C     0001          CHAIN     SINTS
     C                   IF        %FOUND
     C**********         ADD       NORE          WNORE                                        263800
     C                   ADD       WNORE         NORE                                         263800
     C                   EXCEPT    INTSTO
     C                   ENDIF
     C                   ENDIF
                                                                                              263800
      ** MATLNZX                                                                              263800
                                                                                              263800
     C                   Z-ADD     0             WNORE                                        263800
     C     1             CHAIN     MATLNZX                            30                      263800
     C                   IF        %FOUND                                                     263800
     C     NORE          SUB       2             WNORE                                        263800
     C                   ENDIF                                                                263800
     C     WNORE         IFGT      0                                                          263800
     C     1             CHAIN     MATLS                                                      263800
     C                   IF        %FOUND                                                     263800
     C                   ADD       WNORE         NORE                                         263800
     C                   EXCEPT    MATLNO                                                     263800
     C                   ENDIF                                                                263800
     C                   ENDIF                                                                263800

     C**********         EXSR      *PSSR
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Initializing the LDA information

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
     C                   EVAL      DBPGM  = 'LE007050'
     C                   OUT       LDA

     C                   ENDSR

      *****************************************************************

      /EJECT

      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************

     OCONFSTTF  E            CONFSO
     O                       NORE

     OCUTX1TTF  E            CUTX1O
     O                       NORE

     OLETLXTTF  E            LETLXO
     O                       NORE

     OINTSSTTF  E            INTSTO
     O                       NORE
                                                                                              263800
     OMATLNTTF  E            MATLNO                                                           263800
     O                       NORE                                                             263800
     O***MKEYZZF   E            MKEYO
     O**********                 NORE
     O**********                 VRRF
     O**********                 VRRL

      /EJECT
