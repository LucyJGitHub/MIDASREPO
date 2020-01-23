     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Initialisation Program for CLE070')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000360 - Midas LE Initialisation Program for CLE070        *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Called By : LEC000360                                        *
      *                                                               *
      *  Last Amend No. CLE070  *Create    Date 19Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE070 - Manual Diary                                        *
      *                                                               *
      *****************************************************************
     FLEDIAHPD  UF A E           K DISK    INFSR(*PSSR)
     FLEDIATPD  UF A E           K DISK    INFSR(*PSSR)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** Data Structures for use with access programs

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Bank details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short Data Structure

     D PRTCD           S              7A
     D POPTN           S              7A
     D @RUN            S              1A

      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN - Main body                                             *
      *                                                               *
      *****************************************************************

      ** Populate header file

     C                   READ      LEDIAHPD                               01

     C                   EVAL      RECI = 'H'
     C                   EVAL      DYRF = 0
     C                   WRITE     DIARYH1F

      ** Populate trailer file

     C                   READ      LEDIATPD
     C                   EVAL      RECI = 'T'
     C                   EVAL      DYRF = 999999
     C                   EVAL      NORE = 2
     C                   EVAL      NLRB = 2
     C                   EVAL      NINS = 0
     C                   EVAL      NAMD = 0
     C                   EVAL      NDEL = 0
     C                   EVAL      CHTP = *BLANKS
     C                   WRITE     DIARYT1F

     C                   MOVE      *ON           *INLR
     C                   RETURN
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
     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2019
