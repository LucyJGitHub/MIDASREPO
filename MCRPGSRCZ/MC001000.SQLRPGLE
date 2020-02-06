     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Update Posting Date to RUND')
      *****************************************************************
      *                                                               *
      *  Midas - Management Accounting Module                         *
      *                                                               *
      *  MC001000 - Midas MC Update Posting Date to RUND              *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CMC004  *CREATE    Date 13Jul18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMC004 -  Update MC Control groups after FC Transfer         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

     D RUNDAT        E DS                  EXTNAME(RUNDAT)

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C/exec SQL
     C+  update GLEODPTD
     C+  set PSTD = :AGRDNB
     C/end-exec
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2018
