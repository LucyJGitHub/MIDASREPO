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
      *  Last Amend No. MD058100           Date 20May21               *
      *  Prev Amend No. LUC139  *Create    Date 20Jan21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058100 - Rollup of additional BoI onsite fixes at FbMidas  *
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


     FBVCLOANKXPIF   E           K DISK    INFSR(*PSSR)
      * From IALIVE/BVCLOANKXP
     FXXCLT1L0  UF A E           K DISK    INFSR(*PSSR)

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

     ILECLT1D0
     I              PFLNRF                      PFLNRFN
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Loans
      *
     C                   READ      BVCLOANKXP
     C                   DOW       NOT %EOF(BVCLOANKXP)
     C                   Movel     PFLNRF        PFLNRFN
      * All other file feilds match off
      *
     C                   Write     LECLT1D0
     C                   Read      BVCLOANKXP
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
