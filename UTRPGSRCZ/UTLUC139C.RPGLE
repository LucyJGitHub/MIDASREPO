     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT BOI Italy File Take-on')                      *
      *****************************************************************
      *                                                               *
      *  Midas - BOI Returns                                          *
      *                                                               *
      *  UTLUC139 - Midas UT Bank of Italy returns File Take-on       *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. LUC139  *Create    Date 20Jan21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FERITGEPD  IF   E           K DISK    INFSR(*PSSR)
     FERGUEXPD  O    E           K DISK    INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+

      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

     IERITGED0
     I              RTRCUS                      I#RCUS
     I              RTGCOD                      I#GCOD
     I              RTSBYR                      I#SBYR
     I              RTGVBY                      I#GVBY
     I              RTUTSR                      I#UTSR
     I              RTGECD                      I#GECD
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   READ      ERITGEPD
     C                   DOW       NOT %EOF(ERITGEPD )

     C                   MOVEL     I#RCUS        RTRCUS
     C                   Z-ADD     I#GCOD        RTGCOD
     C                   MOVEL     I#SBYR        RTSBYR
     C                   MOVEL     I#GVBY        RTGVBY
     C                   MOVEL     I#UTSR        RTUTSR
     C                   Z-ADD     I#GECD        RTGECD
     C                   MOVEL     I#UTSR        QQUTSR

     C                   Write     ERGUEXD0

     C                   Read      ERITGEPD

     C                   Enddo

     C                   Eval      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
