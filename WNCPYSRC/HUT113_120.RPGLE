      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  SDCUSDSIN                                                    *
      *                                                               *
      *  Last Amend No. HUT113    *CREATE  Date 28May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full PB Functionality in FM                         *
      *           (Upgrade HUT026 to FM 2.1 SP22)                     *
      *                                                               *
      *****************************************************************
      ** Customer Ext in File Format                                                         HUT113
     D CuXcFilFmt    E DS                  EXTNAME(SDCUSTXC)                                 HUT113
      ** FATCA Customer Details in file format                                               HUT113
     D CuFaFilFmt    E DS                  EXTNAME(SDFTCSPD)                                 HUT113
      ** Transaction Details in File Format                                                  HUT113
     D CrsdFilFmt    E DS                  EXTNAME(SDCRSHPD)                                 HUT113
     D PCrsdF          S            219A   DIM(30)                                           HUT113
                                                                                             HUT113
      ** Currency/Time of Netting Details File Format                                        HUT113
     D CtnmFilFmt    E DS                  EXTNAME(SDVCTNMPD)                                HUT113
                                                                                             HUT113
      ** Marketing Information                                                               HUT113
     D TranInCumi    E DS                  EXTNAME (SDCUMIPD)                                HUT113
     D A9_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
                                                                                             HUT113
      ** Additional Customer                                                                 HUT113
     D TranInCuad    E DS                  EXTNAME (SDCUADPD)                                HUT113
     D B1_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
     D A2_DDCNA1     E                     EXTFLD(DDCNA1)                                    HUT113
     D A3_DDCNA2     E                     EXTFLD(DDCNA2)                                    HUT113
     D A4_DDCNA3     E                     EXTFLD(DDCNA3)                                    HUT113
     D A8_DDCNA4     E                     EXTFLD(DDCNA4)                                    HUT113
     D A2_DDCSSN     E                     EXTFLD(DDCSSN)                                    HUT113
     D A1_DDCITY     E                     EXTFLD(DDCITY)                                    HUT113
                                                                                             HUT113
      ** Service Fees                                                                        HUT113
     D TranInSfee    E DS                  EXTNAME (SDSFEEPD)                                HUT113
     D A1_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
                                                                                             HUT113
      ** Cheques and Card Details                                                            HUT113
     D TranInChec    E DS                  EXTNAME (SDCHECPD)                                HUT113
     D A2_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
                                                                                             HUT113
      ** Safe Details                                                                        HUT113
     D TranInCusf    E DS                  EXTNAME (SDCUSFPD)                                HUT113
     D A3_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
                                                                                             HUT113
      ** FX netting Details                                                                  HUT113
     D TranInCufx    E DS                  EXTNAME (SDCUFXPD)                                HUT113
     D A4_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
      ** Fiduciary Details                                                                   HUT113
     D TranInCufd    E DS                  EXTNAME (SDCUFDPD)                                HUT113
     D A5_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
                                                                                             HUT113
      ** Risk Weighted Assets                                                                HUT113
     D TranInRwan    E DS                  EXTNAME (SDRWANPD)                                HUT113
     D A6_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
     D A1_DDCSSN     E                     EXTFLD(DDCSSN)                                    HUT113
     D A1_DDCRNM     E                     EXTFLD(DDCRNM)                                    HUT113
     D A1_DDCNA2     E                     EXTFLD(DDCNA2)                                    HUT113
                                                                                             HUT113
      ** Future and Options                                                                  HUT113
     D TranInCufo    E DS                  EXTNAME (SDCUFOPD)                                HUT113
     D A7_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
     D A1_DDSMAC     E                     EXTFLD(DDSMAC)                                    HUT113
                                                                                             HUT113
      ** Portfolio Management                                                                HUT113
     D TranInCupm    E DS                  EXTNAME (SDCUPMPD)                                HUT113
     D A8_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
                                                                                             HUT113
      ** TI Details                                                                          HUT113
     D TranInTicd    E DS                  EXTNAME (SDTICDPD)                                HUT113
     D B2_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
      ** Currency/Time of Netting                                                            HUT113
     D TranInCtnm    E DS                  EXTNAME (SDCCTNPD)                                HUT113
     D CT_DDACTN     E                     EXTFLD(DDACTN)                                    HUT113
     D CT_DDCUST     E                     EXTFLD(DDCUST)                                    HUT113
     D CT_DDNTCP     E                     EXTFLD(DDNTCP)                                    HUT113
                                                                                             HUT113
     D CuCuxc        E DS                  EXTNAME(SDCUXCPD)                                 HUT113
     D CuFATC        E DS                  EXTNAME(SDFTCRPD)                                 HUT113
     D  DDCUST1      E                     EXTFLD(DDCUST)                                    HUT113
      ** SDCRSSPD Transaction Details in Screen Format                                       HUT113
     D CrsdDets      E DS                  EXTNAME(SDCRSSPD)                                 HUT113
     D                                     PREFIX(A_)                                        HUT113
                                                                                             HUT113
      *****************************************************************
      * End of /COPY HUT113_120                                       *
      *****************************************************************
