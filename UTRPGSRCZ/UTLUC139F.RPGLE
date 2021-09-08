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

     FIIRMPSTPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(IRAPOSD0:I#IRAPOSD0)
     FIRMPSTPD  O    E           K DISK    INFSR(*PSSR)

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

     II#IRAPOSD0
     I              IBCNUM                      I#IBCNUM
     I              IBACOD                      I#IBACOD
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   READ      IIRMPSTPD
     C                   DOW       NOT %EOF(IIRMPSTPD)
     C
     C                   Movel     I#IBCNUM      IBCNUM
     C                   Move      '0000000000'  IBACOD
     C                   Movel     I#IBACOD      IBACOD
     C                   Write     IRAPOSD0

     C                   Read      IIRMPSTPD

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
