     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE PDCL Sett Acct Available Balance Report')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000496 - Midas LE PDCL Sett Acct Available Balance Report  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD038473           Date 02Jun16               *
      *  Prev Amend No. MD036207           Date 02Jun16               *
      *                 CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD038473 - LEC000496 in MSGW during COB                      *
      *  MD036207 - LEC000496 being on MSGW during COB                *
      *           - Applied for MD-38473                              *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *                                                               *
      *****************************************************************
     FLE000496P0O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
     FLE000496P1O    E             PRINTER INFDS(SPOOL2)
     F                                     OFLIND(*IN51)
     FLE000496P2O    E             PRINTER INFDS(SPOOL3)
     F                                     OFLIND(*IN52)
     FLE000496P3O    E             PRINTER INFDS(SPOOL4)
     F                                     OFLIND(*IN53)

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
     D  GetOrder       PR             6A
     D    SortOder                    1A

     D RetrieveCCY     PR                  EXTPGM('AOCURRR0')
     D  pReturnCode                   7A
     D  pOption                       7A
     D  pCurrency                     3A
     D  pDSSDY                      200A

     D RetrieveCus     PR                  EXTPGM('AOCUSTR0')
     D  pReturnCode                   7A
     D  pOption                       7A
     D  pCnum                        10A
     D  pkeysti                       7A
     D  pDSSDY                      200A

     D ACCESS_SVAL     PR                  EXTPGM('AOSVALR0')
     D pRetCode                       7A
     D pOP01                         20A
     D pVL01                        200A
     D pOP02                         20A
     D pVL02                        200A
     D pOP03                         20A
     D pVL03                        200A
     D pOP04                         20A
     D pVL04                        200A
     D pOP05                         20A
     D pVL05                        200A
     D pOP06                         20A
     D pVL06                        200A
     D pOP07                         20A
     D pVL07                        200A
     D pOP08                         20A
     D pVL08                        200A
     D pOP09                         20A
     D pVL09                        200A
     D pOP10                         20A
     D pVL10                        200A

     D EditAmount      PR                  EXTPGM('ZSEDIT')
     D  pZField                      15p 0
     D  pZDec                         1p 0
     D  pZecode                       1a
     D  pzOut21                      21a

     D RetrieveBANK    PR                  EXTPGM('AOBANKR0')
     D  pReturnCode                   7A
     D  pOption                       7A
     D  pDSSDY                      200A

     D ConvertDate     PR                  EXTPGM('ZDATE2')
     D  pDayNo                        5  0
     D  pDateFormat                   1A
     D  pValueDate                    6  0
     D  pRunDate                      7A

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D RepaymentKey  E DS                  EXTNAME(SDRPKYTD)
     D RepaymentDetl E DS                  EXTNAME(LETMPLTD)
     D Currencies      S                   INZ DIM(250) LIKE(SEACCY)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D                                     OCCURS(250)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D                                     OCCURS(2500)
     D IDXCUR          S              3  0 INZ(1)
     D CURLKUP         S              1  0 INZ(0)
     D pDSSDY          S            200A

     D SPOOL1          DS
     D SFILE1                 83     92
     D SFNUM1                123    124B 0
     D OFLLN1                188    189B 0
     D PRTLN1                367    368B 0
     D SPOOL2          DS
     D SFILE2                 83     92
     D SFNUM2                123    124B 0
     D OFLLN2                188    189B 0
     D PRTLN2                367    368B 0
     D SPOOL3          DS
     D SFILE3                 83     92
     D SFNUM3                123    124B 0
     D OFLLN3                188    189B 0
     D PRTLN3                367    368B 0
     D SPOOL4          DS
     D SFILE4                 83     92
     D SFNUM4                123    124B 0
     D OFLLN4                188    189B 0
     D PRTLN4                367    368B 0

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+
     D HIGH            C                   CONST(1)
     D LOW             C                   CONST(-1)
     D EQUAL           C                   CONST(0)
     D NOT_EXIST       C                   CONST(-204)
     D NO_ERROR        C                   CONST(0)
     D NO_RECORD       C                   CONST(100)
     D TABLE_CREATED   C                   CONST(7905)
     D IGNORE_ERROR    C                   CONST(30)
     D QUO             C                   CONST('''')
     D USER_PRIV       C                   CONST(-501)

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D SortSequence    S           2000A   INZ(*BLANKS)
     D wSqlStr         S           2000A   INZ(*BLANKS)
     D SettlementAcct  S             24A   INZ(*BLANKS)
     D CustomerNmbr    S              6A   INZ(*BLANKS)
     D FirstPass       S               N
     D pReturnCode     S              7A
     D pOption         S              7A
     D pDayNo          S              5  0
     D pDateFormat     S              1A
     D pValueDate      S              6  0
     D pRunDate        S              7A
     D RepKey          S             20A   DIM(7)
     D DsplyRep        S             20A   DIM(7)
     D RepSeq          S              2  0 DIM(7)
     D DsplySeq        S              2  0 DIM(7)
     D RepNum          S              2  0
     D N               S              2  0
     D M               S              2  0
     D wHeadCount      s              3  0 INZ(001)
     D wDtlsCount      s              3  0 INZ(001)
     D wZField         s             15p 0
     D wZDec           s              1p 0
     D wZecode         s              1a
     D wzOut21         s             21a
     D pkeysto         s              7a
     D pCnumi          s             10a
     D Availbalbycust  s              1a
     D*PAGEP2***       s              5  0 INZ(0001)                            MD036207
     D PAGEP2          s              6  0 INZ(0001)                            MD036207
     D PAGEP1          s              6  0 INZ(0001)                            MD036207

      ** AOSVALR0 Parameters
     D pRetCode        S              7A
     D pOP01           S             20A
     D pVL01           S            200A
     D pOP02           S             20A
     D pVL02           S            200A
     D pOP03           S             20A
     D pVL03           S            200A
     D pOP04           S             20A
     D pVL04           S            200A
     D pOP05           S             20A
     D pVL05           S            200A
     D pOP06           S             20A
     D pVL06           S            200A
     D pOP07           S             20A
     D pVL07           S            200A
     D pOP08           S             20A
     D pVL08           S            200A
     D pOP09           S             20A
     D pVL09           S            200A
     D pOP10           S             20A
     D pVL10           S            200A

     D/COPY ZSRSRC,ZFRPEDZ1LE

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

                   exsr buildFileByKey;

                   exsr determineRepaymentSequence;

                   exsr availableBalanceBySettlementAcct;

                   exsr access_systemvalues;

                   if Availbalbycust = 'Y';
                      exsr availableBalanceByCustomer;
                   endif;

                   *inlr = *On;
                   return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // getCurrency                                                *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr getCurrency;
                   CURLKUP = %Lookup(SEACCY:Currencies);
                   if CURLKUP > 0;
                      %Occur(SDCURR) = CURLKUP;
                   else;
                      Currencies(IdxCur) = A6CYCD;
                      IdxCur = IdxCur + 1;
                      %Occur(SDCURR) = IdxCur;
                      pOption = '*KEY';
                      RetrieveCCY(pReturnCode:pOption:SEACCY:SDCURR);
                      ZECODE = 'A';
                      ZDECS    = A6NBDP;
                   endif;
       endsr;

       //*************************************************************
       //                                                            *
       // getCustomer                                                *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr getCustomer;

                      pOption = '*KEY';
                      pcnumi = '*BLANKS';
                      pcnumi = SECNUM;
                      RetrieveCus(pReturnCode:pOption:pcnumi:pkeysto:SDCUST);
                      P1CSSN = BBCSSN;
                      P1CRNM = BBCRNM;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // determineRepaymentSequence                                 *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr determineRepaymentSequence;

       // Retrieve sorting sequence from Repayment Key File
                   wsqlStr = 'select * from SDRPKYTD ' +
                             'where RPKPOS <> 0 ' +
                             'order by RPKPOS';

                   exec sql prepare C3 from :wsqlStr;
                   exec sql declare C3 cursor for C3;
                   exec sql open C3;
                   exec sql fetch next from C3 into :RepaymentKey;

                   if sqlCod = USER_PRIV;
                      exec sql open C3;
                      exec sql fetch next from C3 into :RepaymentKey;
                   endif;

                   if sqlcod <> NO_ERROR and sqlcod <> NO_RECORD;
                      dBkey = *blanks;
                      dBfile = 'SDRPKYTD';
                      dBase = 001;
                      dBpgm  = 'LE000496';
                      exsr *pssr;
                   endif;

                   page0 = 1;
                   write LE000496H0;
                   write LE000496HA;
                   dow sqlcod = NO_ERROR;

                      P0PRIO = RPKEYF;
                      P0DESC = RPKDES;
                      P0POSN = RPKPOS;
                      P0ORDR = RPKORD;
                      write LE000496D0;

                      exsr buildSortSequence;

                      exec sql fetch next from C3 into :RepaymentKey;

                      if sqlcod <> NO_ERROR and sqlcod <> NO_RECORD;
                         dBkey = *Blanks;
                         dBfile = 'SDRPKYTD';
                         dBase = 002;
                         dBpgm  = 'LE000496';
                         exsr *pssr;
                      endif;

                   enddo;
                   SortSequence = %Subst(%Trim(SortSequence):1:
                                  %Len(%Trim(SortSequence))-1);

                   P0SORT = SortSequence;
                   write LE000496S0;
                   exec sql close C3;
                   write LE000496T0;

       endsr;

       //*************************************************************
       //                                                            *
       // availableBalanceBySettlementAcct                           *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr availableBalanceBySettlementAcct;

       // Retrieve sorting sequence from Repayment Key File
                   wsqlStr = 'select * from LEXTRCTD ' +
                             'order by SEKEYF, ' + SortSequence;

                   exec sql prepare C2 from :wsqlStr;
                   exec sql declare C2 cursor for C2;
                   exec sql open C2;
                   exec sql fetch next from C2 into :RepaymentDetl;

                   if sqlcod <> NO_ERROR and Sqlcod <> NO_RECORD;
                      dBkey = *Blanks;
                      dBfile = 'LEXTRCTD';
                      dBase = 003;
                      dBpgm  = 'LE000496';
                      exsr *pssr;
                   endif;

                   FirstPass = *On;
                   dow sqlcod = NO_ERROR;

                      exsr processBySettlementAcct;

                      exec sql fetch next from C2 into :RepaymentDetl;

                      if sqlcod <> NO_ERROR and sqlcod <> NO_RECORD;
                         dBKey = *Blanks;
                         dBfile = 'LEXTRCTD';
                         dBase = 004;
                         dBpgm  = 'LE000496';
                         exsr *pssr;
                      endif;

                   enddo;

                   if PrtLn1 > 60 Or PrtLn3 > 60;
                      exsr printHeaderSEAC;
                   endif;

                   write LE000496T1;
                   write LE496P2T1;

                   exec sql close C2;

       endsr;

       //*************************************************************
       //                                                            *
       // access_systemvalues                                        *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************
       begsr access_systemvalues;

                   pOP01 = 'PDP_AvailbalbyCust';

                   CallP ACCESS_SVAL(
                                       pRetCode
                                     : pOP01
                                     : pVL01
                                     : pOP02
                                     : pVL02
                                     : pOP03
                                     : pVL03
                                     : pOP04
                                     : pVL04
                                     : pOP05
                                     : pVL05
                                     : pOP06
                                     : pVL06
                                     : pOP07
                                     : pVL07
                                     : pOP08
                                     : pVL08
                                     : pOP09
                                     : pVL09
                                     : pOP10
                                     : pVL10
                                       );
                   If pRetCode <> *Blanks;
                      DbFile = 'SDSVALPD';
                      Dbase  = 2;
                      DbKey  = pOP01;
                      DbPgm  = 'LE000496';
                      Exsr *Pssr;
                   Endif;

                   Availbalbycust = pVL01;
       endsr;

       //*************************************************************
       //                                                            *
       // availableBalanceByCustomer                                 *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr availableBalanceByCustomer;

                        exec sql prepare C4 from :wsqlStr;
                        exec sql declare C4 cursor for C4;
                        exec sql open C4;
                        exec sql fetch next from C4 into :RepaymentDetl;

                        if sqlcod <> NO_ERROR and Sqlcod <> NO_RECORD;
                           dBkey = *Blanks;
                           dBfile = 'LEXTRCTD';
                           dBase = 003;
                           dBpgm  = 'LE000496';
                           exsr *pssr;
                        endif;

                   FirstPass = *On;

                   PAGE = 0;

                   dow sqlcod = NO_ERROR;

                      exsr processByCustomer;

                      exec sql fetch next from C4 into :RepaymentDetl;

                      if sqlcod <> NO_ERROR and sqlcod <> NO_RECORD;
                         dBKey = *Blanks;
                         dBfile = 'LEXTRCTD';
                         dBase = 004;
                         dBpgm  = 'LE000496';
                         exsr *pssr;
                      endif;

                   enddo;

                   if PrtLn4 > 60;
                      exsr printHeaderCUST;
                   endif;

                   write LE000497T1;

                   exec sql close C4;

        endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // buildSortSequence                                          *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr buildSortSequence;
                   select;
                      when %Trim(RPKEYF) = 'RepaymentPR';
                         sortSequence = %TRIM(SortSequence) + 'SEREPR ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'CategoryCOPR';
                         sortSequence = %TRIM(SortSequence) + 'SECAPR ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'ORTStartDate';
                         sortSequence = %TRIM(SortSequence) + 'SESDAT ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'ORTEndDate';
                         sortSequence = %TRIM(SortSequence) + 'SEMDAT ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'Reference';
                         sortSequence = %TRIM(SortSequence) + 'SETREF ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'PAYValueDate';
                         sortSequence = %TRIM(SortSequence) + 'SEVDPY ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'PDCLValueDate';
                         sortSequence = %TRIM(SortSequence) + 'SEVDPD ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'Amount';
                         sortSequence = %TRIM(SortSequence) + 'SEPAMT ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'Timestamp';
                         sortSequence = %TRIM(SortSequence) + 'SETMST ' +
                                        getOrder(RPKORD);
                   endsl;
       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // seupHeaders                                                *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr setupHeaders;
                   if SEC205 = 'Y';
                      *in50 = *On;
                   endif;
                   SettlementAcct = SEKEYF;
                   CustomerNmbr = SECNUM;
                   SEBRCAH = SEBRCA;
                   SEACCYH = SEACCY;
                   SECNUMH = SECNUM;
                   SEACODH = SEACOD;
                   SEACSQH = SEACSQ;
                   SEACNOH = SEACNO;

                   // ABC Flag
                   SEABCFH = 'No';
                   if SEABCF = 'Y';
                      SEABCFH = 'Yes';
                   endif;
                   // Blocked Debits Indicator
                   SERETBH = 'No';
                   if SERETB = 'Y';
                      SERETBH = 'Yes';
                   endif;

                   // Opening Balance
                   ZFLD15 = SEAAMT;
                   exsr FormatAmt;
                   W@OPEN = ZOUT22;

                   // Cleared Balance +/- Adjustments
                   ZFLD15 = SECLBL;
                   exsr FormatAmt;
                   W@CLBL = ZOUT22;

                   // Held Items
                   wZField = SEHELD;
                   wzDec = A6NBDP;
                   WZeCode = 'J';
                   wZout21 = *blanks;
                   Callp EditAmount(  wZField
                                     :wZDec
                                     :wZecode
                                     :wZout21
                                   );

                   W@HELD = wZout21;

                   // Overdraft Amount
                   wZField = SEOAMT *-1;
                   wzDec = A6NBDP;
                   wZout21 = *blanks;
                   Callp EditAmount(  wZField
                                     :wZDec
                                     :wZecode
                                     :wZout21
                                   );

                   W@OVLN = wZout21;

                   // Blocked Collateral
                   ZFLD15 = SECOLL;
                   exsr FormatAmt;
                   W@COLL = ZOUT22;
       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processBySettlementAcct                                    *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr processBySettlementAcct;
                   if SECNUM <> *blanks and
                      SEACCY <> *blanks and
                      SEACOD <> *zeros  and
                      SEACSQ <> *zeros  and
                      SEBRCA <> *blanks;

                      exsr getCurrency;
                      if FirstPass = *On;
                         exsr setupHeaders;
                         exsr printHeaderSEAC;
                         FirstPass = *Off;
                      else;
                         if SettlementAcct <> SEKEYF;
                            SettlementAcct = SEKEYF;
                            exsr setupHeaders;
                            exsr printHeaderSEAC;
                         endif;
                      endif;

                      exsr printDetailSEAC;

                   endif;

       endSr;

       //*************************************************************
       //                                                            *
       // processByCustomer                                          *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr processByCustomer;

                 exsr getCustomer;
                 if FirstPass = *On;
                    exsr setupHeaders;
                    exsr printHeaderCUST;
                    FirstPass = *Off;
                 else;
                    if CustomerNmbr <> SECNUM;
                       CustomerNmbr = SECNUM;
                       exsr setupHeaders;
                       exsr printHeaderCUST;
                    endif;
                 endif;

                 exsr printDetailCUST;

       endsr;
       //*************************************************************
       //                                                            *
       // printHeaderSEAC                                            *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr printHeaderSEAC;

                   write LE000496H1;
                   write LE000496H2;
                   write LE000496H3;

                   write LE496P2H1;
                   write LE496P2H2;
                   write LE496P2H3;
                   write LE496P2HZ;

                   PAGEP2 = PAGEP2 + 1;
                   PAGEP1 = PAGEP1 + 1;                                        //MD036207
       endsr;
       //*************************************************************
       //                                                            *
       // printHeaderCUST                                            *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr printHeaderCUST;
                   write LE000497H1;
                   write LE000497H2;
                   write LE000497H3;
       endsr;
       //*************************************************************
       //                                                            *
       // printDetailSEAC                                            *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr printDetailSEAC;

                   P1FILE = SEFILE;
                   P1REFN = SETREF;
                   P1CATE = SECATC;
                   P1REPR = SEREPR;
                   P1CATE = SECATC;

                   if SERETB <> 'Y';
                      ZFLD15 = 0;
                      if SEAAMT <> 0;
                         ZFLD15 = SEAAMT;
                      endif;

                      if SEOVFL = 'Y';
                         if SEAVOD <> 0;
                            ZFLD15 = SEAVOD;
                         endif;
                      endif;
                      exsr FormatAmt;
                      P1AAMT = ZOUT22;

                      ZFLD15 = SERAMT;
                      exsr FormatAmt;
                      P1RAMT = ZOUT22;

                      ZFLD15 = SEEAMT;
                      exsr FormatAmt;
                      P1EAMT = ZOUT22;

                      if SEOVFL = 'Y';
                         P1OVRD = SEOVFL;
                      else;
                         P1OVRD = *blanks;
                      endif;
                   else;

                      ZFLD15 = 0.00;
                      exsr FormatAmt;
                      P1AAMT = ZOUT22;

                      ZFLD15 = SEEAMT;
                      exsr FormatAmt;
                      P1EAMT = ZOUT22;

                      ZFLD15 = 0.00;
                      exsr FormatAmt;
                      P1RAMT = ZOUT22;

                   endif;

                   if PrtLn1 > 60 Or PrtLn3 > 60;
                      exsr PrintHeaderSEAC;
                   endif;

                   pDayNo = SEVDAT;
                   pDateFormat = BJDFIN;
                   pValueDate = 0;
                   pRunDate = *Blanks;
                   ConvertDate(
                                 pDayNo
                               : pDateFormat
                               : pValueDate
                               : pRunDate
                              );
                   P1VDAT = pRunDate;
                   Write LE000496D1;
                   exsr buildDetailByKey;
                   Write LE496P2D1;
       endsr;

       //*************************************************************
       //                                                            *
       // printDetailCUST                                            *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr printDetailCUST;

              P1FILE = SEFILE;
              P1REFN = SETREF;

              P1SETAC = SEBRCA + '-' +
                        SECNUM + '-' +
                        SEACCY + '-' +
                        %EDITC(SEACOD : 'X') + '-' +
                        %EDITC(SEACSQ : 'X');

              P1CATE = SECATC;
              P1REPR = SEREPR;
              P1CATE = SECATC;
              P1ACCY = SEACCY;
              P1SEALTA = SEALTA;
              P1SEALTSQ = SEALTSQ;

              if SERETB <> 'Y';
                 ZFLD15 = 0;
                 if SEAAMT <> 0;
                    ZFLD15 = SEAAMT;
                 endif;

                 if SEOVFL = 'Y';
                    if SEAVOD <> 0;
                       ZFLD15 = SEAVOD;
                    endif;
                 endif;
                 exsr FormatAmt;
                 P1AAMT = ZOUT22;

                 ZFLD15 = SEEAMT;
                 exsr FormatAmt;
                 P1EAMT = ZOUT22;

              else;

                 ZFLD15 = 0.00;
                 exsr FormatAmt;
                 P1AAMT = ZOUT22;

                 ZFLD15 = SEEAMT;
                 exsr FormatAmt;
                 P1EAMT = ZOUT22;

              endif;

              if PrtLn4 > 60;
                 exsr PrintHeaderSEAC;
              endif;

              pDayNo = SEVDAT;
              pDateFormat = BJDFIN;
              pValueDate = 0;
              pRunDate = *Blanks;
              ConvertDate(
                            pDayNo
                          : pDateFormat
                          : pValueDate
                          : pRunDate
                         );
              P1VDAT = pRunDate;
              Write LE000497D1;
       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // INZSR - Program Initialisation routine                     *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr *Inzsr;
                   pOption = '*FIRST';
                   RetrieveBank(
                                  pReturnCode
                                : pOption
                                : pDSSDY
                               );
                   SDBANK = pDSSDY;

                   PrtLn1 = 0;                                                            //MD038473
                   PrtLn2 = 0;                                                            //MD038473
                   PrtLn3 = 0;                                                            //MD038473
                   PrtLn4 = 0;                                                            //MD038473
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *PSSR  - Program Error Processing Subroutine.            *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr *Pssr;
                   *Inu7 = *ON;
                   *Inu8 = *ON;
                   Dump;
                   *Inlr = *ON;
                   Return;
       endsr;

       //*************************************************************
       //                                                            *
       // BuildFileByKey - Build Extract Files arranged by Key       *
       //                  Report                                    *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr BuildFileByKey;

                   RepKey(1) = 'PAYValueDate';
                   RepSeq(1) = 12;
                   RepKey(2) = 'Amount';
                   RepSeq(2) = 20;
                   RepKey(3) = 'ORTEndDate';
                   RepSeq(3) = 10;
                   RepKey(4) = 'Timestamp';
                   RepSeq(4) = 26;
                   RepKey(5) = 'ORTStartDate';
                   RepSeq(5) = 12;
                   RepKey(6) = 'PDCLValueDate';
                   RepSeq(6) = 13;
                   RepKey(7) = 'CategoryCOPR';
                   RepSeq(7) = 12;

                   wsqlStr = 'select * from SDRPKYTD ' +
                             'where RPKPOS <> 0 ' +
                             'order by RPKPOS';

                   exec sql close C1;
                   exec sql Prepare C1 from :wsqlStr;
                   exec sql Declare C1 cursor for C1;
                   exec sql Open C1;
                   exec sql fetch next from C1 into :RepaymentKey;

                   if Sqlcod <> NO_ERROR and Sqlcod <> NO_RECORD;
                      dBkey = *Blanks;
                      dBfile = 'SDRPKYTD';
                      dBase = 005;
                      dBpgm  = 'LE000496';
                      exsr *Pssr;
                   endif;

                   dow Sqlcod = NO_ERROR;

                      N = %LookUp(RPKEYF:RepKey);
                      if N <> 0;
                         w@Head = %Replace(RPKEYF:w@Head:wHeadCount);
                         wHeadCount = wHeadCount + RepSeq(N) + 2;
                         M = M + 1;
                         DsplyRep(M) = RepKey(N);
                         DsplySeq(M) = RepSeq(N);
                      endif;

                      exec sql fetch next from C1 into :RepaymentKey;

                      if sqlcod <> NO_ERROR and sqlcod <> NO_RECORD;
                         dBkey = *Blanks;
                         dBfile = 'SDRPKYTD';
                         dBase = 006;
                         dBpgm  = 'LE000496';
                         exsr *Pssr;
                      endif;
                   enddo;

                   exec sql close C1;

       endsr;

       //*************************************************************
       //                                                            *
       // buildDetailByKey - Build Details arranged by Key Report    *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr buildDetailByKey;

                   wDtlsCount = 1;
                   W@REPR = %EditC(P1REPR:'X');
                   W@FILE = SEFILE;
                   W@TREF = SETREF;
                   N = 1;
                   RepNum = %Elem(RepKey);
                   for N = 1 to RepNum;
                      Select;
                      when DsplyRep(N) = 'PAYValueDate';
                         M = %LookUp(DsplyRep(N):RepKey);
                         w@Dtls = %Replace(P1VDAT:w@Dtls:wDtlsCount);
                         wDtlsCount = wDtlsCount + RepSeq(M) + 2;
                      when DsplyRep(N) = 'Amount';
                         M = %LookUp(DsplyRep(N):RepKey);
                         ZFLD15 = SEPAMT;
                         exsr FormatAmt;
                         w@Dtls = %Replace(ZOUT22:w@Dtls:wDtlsCount);
                         wDtlsCount = wDtlsCount + RepSeq(M) + 2;
                      when DsplyRep(N) = 'ORTEndDate';
                         pDayNo = SEMDAT;
                         pDateFormat = BJDFIN;
                         pValueDate = 0;
                         pRunDate = *Blanks;
                         ConvertDate(
                                       pDayNo
                                     : pDateFormat
                                     : pValueDate
                                     : pRunDate
                                    );
                         M = %LookUp(DsplyRep(N):RepKey);
                         w@Dtls = %Replace(pRunDate:w@Dtls:wDtlsCount);
                         wDtlsCount = wDtlsCount + RepSeq(M) + 2;
                      when DsplyRep(N) = 'Timestamp';
                         M = %LookUp(DsplyRep(N):RepKey);
                         w@Dtls = %Replace(%Char(SETMST):w@Dtls
                                           :wDtlsCount);
                         wDtlsCount = wDtlsCount + RepSeq(M) + 2;
                      when DsplyRep(N) = 'ORTStartDate';
                         M = %LookUp(DsplyRep(N):RepKey);
                         w@Dtls = %Replace(P1VDAT:w@Dtls:wDtlsCount);
                         wDtlsCount = wDtlsCount + RepSeq(M) + 2;
                      when DsplyRep(N) = 'PDCLValueDate';
                         pDayNo = SEVDPD;
                         pDateFormat = BJDFIN;
                         pValueDate = 0;
                         pRunDate = *Blanks;
                         ConvertDate(
                                       pDayNo
                                     : pDateFormat
                                     : pValueDate
                                     : pRunDate
                                    );
                         M = %LookUp(DsplyRep(N):RepKey);
                         w@Dtls = %Replace(pRunDate:w@Dtls:wDtlsCount);
                         wDtlsCount = wDtlsCount + RepSeq(M) + 2;
                      when DsplyRep(N) = 'CategoryCOPR';
                         M = %LookUp(DsplyRep(N):RepKey);
                         w@Dtls = %Replace(%EditC(SECAPR:'X'):w@Dtls
                                           :wDtlsCount);
                         wDtlsCount = wDtlsCount + RepSeq(M) + 2;
                      endsl;
                   endFor;

       endsr;
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FormatAmt - Formats a numeric amount                         *
      *                                                               *
      *****************************************************************
     C     FormatAmt     BEGSR
     C                   exsr      ZFRPED
     C                   ENDSR
     C/COPY ZSRSRC,ZFRPEDZ2LE
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetOrder - Determine whether ASC or DESC keywoard should     *
      *             be returned                                       *
      *                                                               *
      *****************************************************************

     P GetOrder        B
     D GetOrder        PI             6A
     D   SortOrder                    1A
     D   RetVal        S              6A
     D
     C                   SELECT
     C                   WHEN      SortOrder = 'A'
     C                   EVAL      RetVal = 'ASC'
     C                   WHEN      SortOrder = 'D'
     C                   EVAL      RetVal = 'DESC'
     C                   ENDSL
     C                   EVAL      RetVal  = %TRIM(RetVal) + ', '
     C                   RETURN    RetVal
     P   GetOrder      E

