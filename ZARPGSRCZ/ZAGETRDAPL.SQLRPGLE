     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD API - Get Rounding Applies')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data API - Get Rounding Applies Flag  *
      *                                                               *
      *  ZAGETRDAPL  - Midas API - Get Rounding Applies               *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060008           Date 11May21               *
      *  Prev Amend No. MD059624           Date 20Jul22               *
      *****************************************************************
      *                                                               *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *  MD059624 - CCR Rounding parameters for NCCR calculation CC8  *
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

     D Main            pr                  extpgm('ZAGETRDAPL')
      **-----------------------------------------------------**
     D  RiskFreeRate                 10a
      ** Calculation Method
     D  isRoundApply                  1a
      ** Is rounding Applied

     D Main            pi
      **-----------------------------------------------------**
     D  RiskFreeRate                 10a
      ** Calculation Method
     D  isRoundApply                  1a
      ** Is rounding Applied

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

                   isRoundApply = 'N';

      **********   wSQLStr = 'select ROUAPL from SDLIBRTD' +
      **********                ' where SCRFLD  = ' + QUO + CONST_RFR + QUO +
      **********                ' and INTVAL = ' + QUO + RiskFreeRate + QUO;              //MD060008
                   wSQLStr = 'select ROUAPL from SDLIBJW0' +
                                ' where SCRFLD  = ' + QUO + CONST_RFR + QUO +
                                ' and INTVAL = ' + QUO + RiskFreeRate + QUO;              //MD060008

                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch next From P1 into :isRoundApply;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 001;
                      dBFile   = 'SDLIBRTD';
                      dBkey    = *BLANKS;
                      dBpgm    = 'PROGRAM';
                      exsr *pssr;
                   endif;

                   exec sql close P1;


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

      /end-free

** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2022
