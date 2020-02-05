     H Debug(*yes)
     H COPYRIGHT('(c) Finastra International Limited. 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Zero Interest Rate Loans Report')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEZINTR1  -  Zero Interest Rate Loans Report                 *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD055192           Date 31Jan20               *
      *  Prev Amend No. MD055127           Date 23Jan20               *
      *                 MD055116           Date 21Jan20               *
      *                 CLE170  *CREATE    Date 10Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055192 - BaseRateCode field with Zero value is not         *
      *             considered in the LEZINTP1 report                 *
      *  MD055127 - Non-zero interest rates are being generated for   *
      *             LEZINTP1 for all loan processing types            *
      *  MD055116 - Processing types 70,71 and 72 not included in     *
      *             report.                                           *
      *  CLE170 - Allow Zero Interest Rate Loans                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ***  FILES
      *    =====
      *****************************************************************
      *
      * Lending File
     F***CLoanCL   IF   E             Disk                                                  MD055127
     FCLoanL4   IF   E           K Disk                                                     MD055127

      *------------------------------------------------------------------
      * Bank information
     FSdBankl0  IF   E           K Disk
      *------------------------------------------------------------------
      * Customer information
     FSdCustl0  IF   E           K Disk
      *------------------------------------------------------------------
      * Currency Master
     FSdcurrl0  IF   E           k Disk
      *------------------------------------------------------------------
      * Zero Interest Rate Loans Report
     FLeZIntP1  O    E             Printer Oflind(*In40) Infds(PrintInfo)
      *------------------------------------------------------------------
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
      **--------------------------------------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
     D PrintInfo       DS
     D Linenumber            367    368B 0

      * Workfield definitions
      *
     D ProgramName     S             10    Inz('LeZIntR1')
     D PrinterFile     S             10    Inz('LEZINTP1')

     D WorkAmount      S             16  3 Inz
     D NoOfRec         S              6  0 Inz

     DConvert3         Ds
     D Cvt3A                   1      3
     D Cvt3N                   1      3  0
     DConvert2         Ds
     D Cvt2A                   1      2
     D Cvt2N                   1      2  0

       // Constants Follow
     D EditWord0       C                   ' ,   ,   ,   ,  0'
     D EditWord2       C                   '  ,   ,   ,  0.  '
     D EditWord3       C                   ' ,   ,   ,  0.   '


     D C_Heading_P1    C                   'Zero Interest Rate Loans Report'

      /Free
      **********   Read CloanCL;                                                            MD055127
      **********   Dow Not %Eof(Cloancl);                                                   MD055127
      **********    If PTYP <> 70 And PTYP <> 71 And PTYP <> 72;                            MD055116
                   Read CloanL4;
                   Dow Not %Eof(CloanL4);
                     Exsr WriteReportDtl;
      **********    Endif;                                                                  MD055116
      **********     Read CloanCL;                                                          MD055127
                     Read CloanL4;
                   Enddo;

                   If NoOfRec = 0;
                      Write R1Head;
                      Write R1Norpt;
                   Endif;

        //  End of Processing

                   Write R1End;

                   *Inlr = *On;

        //=====================================================================================
        // Sub-routine WriteReportDtl
        // =====================================================================================
             Begsr WriteReportDtl;

                   If *In40 Or
                      Linenumber > 62;
                      Write R1head;
                      *In40 = *Off;
                   Endif;
        // Only report loan is the Base Rate is zero AND Spread Rate is zero AND has Principal
        //         If BRTT = 0 And RTSP = 0;                                                MD055127
        //         If BRTT = 0 And RTSP = 0 And INTR = 0 and BRTE = 0;                      MD055192
                   If RTSP = 0 And INTR = 0 and BRTE = 0;
        // Customer Number
                         R1CNum  = CNum;
        // Customer Name
        // Retrieve customer shortname
                         Chain CNum Sdcustl0;
                         R1Cnam = BbCsSN;
        // Loan Reference
                         R1LnRf = Lnrf;
        // Loan Type
                         R1LTyp = LTyp;
        // Loan Sub Type
                         R1LsTp = SuTp;
        // Currency
                         R1LCcy = Ccy;

        // Principal amount
        // Retrieve currency decimal places for event amount
                         Chain Ccy Sdcurrl0;

                         WorkAmount = *Zeros;
                         Eval(H) WorkAmount = (CPam / (10 ** A6nbdp));

                         Select;
                         When A6nbdp = 0;
                              R1LPam = %EditW(CPAM : EditWord0);
                         When A6nbdp = 2;
                              R1LPam = %EditW(Cpam       : EditWord2);
                         When A6nbdp = 3;
                              R1LPam = %EditW(Cpam       : EditWord3);
                         Endsl;
        // Start Date
                         ZDayNo = VDat;
                         Exsr Zdate2;
                         R1StrD = ZaDate;
        // Maturity Date
                         ZDayNo = MDat;
                         Exsr Zdate2;
                         R1MatD = ZaDate;
        // Interest Date
                         ZDayNo = NIDt;
                         Exsr Zdate2;
                         R1IntD = ZaDate;
        // Rollover Date
                         ZDayNo = Bjrdnb;
                         Exsr Zdate2;
                         R1RolD = ZaDate;
        // Facility Customer
                         R1FCus  = FCus;
        // Facility Type
                         Cvt3N   = FTyp;
                         R1FTyp  = Cvt3A;
        // Facility Sequence
                         Cvt2N   = FSeq;
                         R1FSeq  = Cvt2A;
        // Inserting User
                         R1IUsr  = IUsr;
        // Amending User
                         R1AUsr  = AUsr;
        // Authorising User
                         R1XUsr  = XUsr;

        // End of Printer file fields to fill
        // Record Count
                         NoOfRec = NoOfRec + 1;
                         Write R1Dets;
                   Endif;

                   Clear R1Dets;
             Endsr;

        //========================================================================
        // Sub-routine *Inzsr
        //=========================================================================
             Begsr *Inzsr;

                   Read Sdbankl0;

                   ZDAYNO = Bjrdnb;
                   Exsr Zdate2;
                   R1Date = ZaDate;
                   R1Title = Bjurpt;
                   R1Heading = C_Heading_P1;
                   *In40 = *On;

             Endsr;

      /End-Free
      *****************************************************************
      * Date Conversion Routine                                       *
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
