     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GO Download Data Control - PDP Bch Bulk Upd')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO000507 - Midas GO Download Data Control - PDP Bch Bulk Upd *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *                                                               *
      *****************************************************************

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D GPDWNL        E DS                  EXTNAME(GPDWNLPD)

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

     D  DWNLCount      S              3  0 INZ(*ZEROS)
     D  zPrefix        S              2A   INZ(*BLANKS)
     D  wKeyDesc       S             20A   INZ('PDPRepMatrixBulkUpd')
     D SDSTAT        E DS                  DTAARA(SDSTAT)

      /free

       // +--- Start of Main processing -----------------------------+
       // ¦                                                          ¦
       // ¦ Initial processing is performed automatically: the       ¦
       // ¦ *INZSR is executed at program activation.                ¦
       // ¦                                                          ¦
       // +----------------------------------------------------------+

                  Exsr SrDWNLUpd;

                  *INLR = *On;

                  Return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   SrDWNLUpd - Update GPDWNLPD                              *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       Begsr SrDWNLUpd;
                  In SDSTAT;
                  zPrefix = Libr;

                  Exec sql
                  select * into :GPDWNL from GPDWNLPD
                  where DLMSID = :zPrefix and DLKEYD = :wKeyDesc;

                  If sqlcod = 100;
                  Exec sql
                  insert into GPDWNLPD (DLMSID, DLKEYD, DLVAL)
                  values (:zPrefix, :wKeyDesc, 'N');
                  Endif;
       Endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *Pssr  - Program Error Processing Subroutine.            *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       Begsr *Pssr;
                  *Inu7 = *ON;
                  *Inu8 = *ON;
                  Dump;
                  *Inlr = *ON;
                  Return;
       Endsr;

      /end-free

