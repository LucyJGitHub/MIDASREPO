     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Utility to synchronize LEAGFTQD with LEAGFMPD')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00310 - Utility to synchronize LEAGFTQD with LEAGFMPD     *
      *                                                               *
      *  Function:  This program will synchronize LEAGFTQD with       *
      *             LEAGFMPD                                          *
      *                                                               *
      *  Called By: SMUC00310                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. MD040963           Date 206Sep16              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040963 - CLE106 initialisation program ended in error      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************

      ** Midas LE Aggregate Facilities Trailer File
     FLEAGFTQD  UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCLTD0:LEAGFTD0)
      ** Midas LE Aggregate Facilities
     FLEAGFCL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
     F                                     RENAME(FCLTYFMF:AGLTYFMF)
     F                                     PREFIX(A)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      *
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

      *****************************************************************
      /EJECT
      *****************************************************************


     C     1             SETLL     LEAGFTQD
     C                   READ      LEAGFTQD                               01

     C                   DOW       *IN01 = *OFF

     C                   MOVEL     FCXFCU        KCNUM             6
     C                   MOVEL     FCXFTP        KFACT             3 0
     C                   MOVEL     FCXFNO        KFCNO             2 0
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     LEAGFCL0

     C                   IF        NOT %FOUND(LEAGFCL0)
     C                   DELETE    LEAGFTQD
     C                   ENDIF

     C                   READ      LEAGFTQD                               01

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   Return

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
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
     C     CHKFAC        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
     C                   KFLD                    KRCTP             1
     C                   ENDSR

