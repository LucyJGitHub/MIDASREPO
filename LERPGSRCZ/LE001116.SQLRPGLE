     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Get History File Details')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE001116 - Midas LE Get History File Details                 *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060441           Date 01Feb23               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD060441 - CLE172 CC9 - Back-valued Rollover to a            *
      *             backward looking rate                             *
      *                                                               *
      *****************************************************************

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.


     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC


      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *  +----------------+
      ** |Parameter lists |
      ** +----------------+

     D Main            pr                  extpgm('LE001116')
      **-----------------------------------------------------**
     D  loanRef                       6a
      ** Loan Reference
     D  typeOfInfo                    2a
      ** Type of Information needed
     D  valueDate                     5p 0
      ** Value Date

     D Main            pi
      **-----------------------------------------------------**
     D  loanRef                       6a
      ** Loan Reference
     D  typeOfInfo                    2a
      ** Type of Information needed
     D  valueDate                     5p 0
      ** Value Date

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      ** +--------------------------------------+

      ** Core data structures
     D dssdy         e ds                  extname(DSSDY)
     D dsfdy         e ds                  extname(DSFDY)

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D QUE             c                   const('?')
     D QUO             c                   const('''')
     D CONST_RFR       c                   const('RFR')

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D wSqlStr         S           2000A   INZ(*BLANKS)
     D RecordExist     S               N   INZ(*OFF)


      ** +--------------------------------------+
      ** ¦ Array declaration                    ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      /free

       // ** +--- Start of Main processing -----------------------------------+
       // ** ¦                                                                ¦
       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
       // ** ¦ executed at program activation.                                ¦
       // ** ¦                                                                ¦
       // ** +----------------------------------------------------------------+

                   select;

                       when typeOfInfo = 'RO';
                            exsr getRolloverInfo;

                       when typeOfInfo = 'IN';
                            exsr getIntPayInfo;

                       when typeOfInfo = 'RE';
                            exsr getRepayInfo;

                   endsl;

                   *Inlr = *On;
                   return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // inzsr - Program Initialisation routine                     *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr *inzsr;

       endsr;


       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   errorHandler  - Program Error Processing Subroutine.     *
       //                                                            *
       //   Called By: Main Processing, various subroutines          *
       //                                                            *
       //*************************************************************

       begsr *pssr;
                   *inu7 = *on;
                   *inu8 = *on;
                   *Inlr = *on;
                   dump;
                   return;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   getRolloverInfo                                          *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr getRolloverInfo;

             exec sql
                  select max(vdat) into :valueDate
                  from HISTSHQ
                  where lnrf = :loanRef and amtp = 'RO';

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   getIntPayInfo                                            *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr getIntPayInfo;

             exec sql
                  select max(vdat) into :valueDate
                  from HISTSHP
                  where lnrf = :loanRef and amtp = 'IN';

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   getRepayInfo                                             *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr getRepayInfo;

             exec sql
                  select max(vdat) into :valueDate
                  from HISTSHP
                  where lnrf = :loanRef and amtp = 'RE';

       endsr;



       //*************************************************************

      /end-free

** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2023
