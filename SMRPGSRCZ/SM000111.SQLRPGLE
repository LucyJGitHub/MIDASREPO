     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Populate LEFEEDQD.FQBRCA')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000111 - Midas SM Populate LEFEEDQD.FQBRCA                 *
      *                                                               *
      *  Function:  This program will update LEFEEDQD.FQBRCA with     *
      *             LEFEED.FEBRCA is left blank                       *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059231 *CREATE   Date 08Nov21               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059231 - Error after migration as LEFEEDQD.FQBRCA was not  *
      *             populated in 11.06                                *
      *                                                               *
      *****************************************************************

     C/EXEC SQL
     C+  WHENEVER SQLERROR GO TO TAGSQLERR
     C/END-EXEC

     C/EXEC SQL
     C+ update lefeedqd q set fqbrca = (select l.febrca from lefeed l
     C+ where q.fqcnum = l.fecnum and q.fqfacl = l.fefacl
     C+ and   q.fqloan = l.feloan and q.fqfseq = l.fefseq)
     C+ where exists (select * from lefeed l
     C+ where q.fqcnum = l.fecnum and q.fqfacl = l.fefacl
     C+ and   q.fqloan = l.feloan and q.fqfseq = l.fefseq)
     C+ and   fqbrca = '   '
     C/END-EXEC

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C     TAGSQLERR     TAG

     C                   EXSR      *PSSR

      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR                                                  ** *PSSR SR **

     C                   DUMP

     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR

