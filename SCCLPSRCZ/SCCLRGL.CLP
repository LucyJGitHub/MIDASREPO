/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Clear GL daily files')                       */
/********************************************************************/
/*                                                                  */
/*       Midas STANDING DATA MODULE                         */
/*                                                                  */
/*       SDCLRGL - CLEAR GENERAL LEDGER DAILY FILES                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CSC056            Date 06Aug12               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CGL030            Date 18Dec09              */
/*                      CAP204            Date 19Feb10              */
/*                      CGL047            Date 30Jun06              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CRE026            Date 24May06               */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      238797            Date 10Mar06               */
/*                      236369            Date 04Jan06               */
/*                      236189            Date 07Apr05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      186206            Date 26Oct00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      122794            Date 18May98              */
/*                      CEU013            DATE 09APR98              */
/*                      135055            Date 12May98              */
/*                      121058            Date 10Feb98              */
/*                      127963            Date 19Oct97              */
/*                      CRE004            Date 31Mar97               */
/*                      119873            DATE 04AUG97               */
/*                      S01408            DATE 14NOV96              */
/*                      CMC001            DATE 05JUL96              */
/*                      S01408            DATE 24JAN96              */
/*                      S01408            DATE 08NOV95              */
/*                      S01408            DATE 23JUN95              */
/*                      CRT001            DATE 28FEB95              */
/*                      S01413            DATE 13JAN94              */
/*                      S01421            DATE 17AUG93              */
/*                      048237            DATE 09FEB92              */
/*                      S10736            DATE 12NOV92              */
/*                      S01340            DATE 23JAN92              */
/*                      S01343            DATE 15AUG91              */
/*                      E15192            DATE  1OCT90              */
/*                      S01196            DATE 11NOV89              */
/*                      S01117            DATE 29/08/89             */
/*                      S1101             DATE 29/07/86             */
/*                      S1102             DATE 29/04/86             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CSC056 - COB Restructure - SC COB Optimisation Phase 1     */
/*       CGL030 - Sundry Postings                                   */
/*       CAP204 - Teller Related APIs - Account Transfer             */
/*       CGL047 - Midas Generic Posting Interface                   */
/*       CRE026 - Consumer Banking                                   */
/*       238797 - Clear file AOSPOSPD. Applied fix 236189.           */
/*       236369 - Move clearing of GLBTNOPD to GLC01 so that batch  */
/*                item no. will not be cleared during reopen i/c.   */
/*       236189 - Clear file AOSPOSPD.                              */
/*       186206 - Journal Entry API fixes. Produce only one dump    */
/*                per JE batch. Generate JE Valid errors report.    */
/*                Prevent record locking error in JE database       */
/*                updater.                                          */
/*       122794 -  CLEAR GEAA2* FILES .Upgrade of 69920             */
/*       CEU013 -  EMU Account Postings Narrative                   */
/*       135055 -  Removes attempted opening of 2 files that do     */
/*                 not exist in the system MCGAP1PD and GEXT        */
/*       121058 -  Retail Statement Charges Fix                     */
/*       127963 -  Extra Entries being posted to Gap/Accrual Account*/
/*       CRE004 -  Sweep Accounting:                                */
/*                 Clear GESPPD, GESPZZ, GESP2PD and GESP2ZZ.       */
/*       119873 -  COB Performance Enhancements.  Clear of          */
/*                 EODPO* files moved.                              */
/*       S01408 -  Addition of core hook SCCLRGL005                 */
/*       CMC001 -  Management Accounts Enhancement for PCA:         */
/*                 Clear GEPCPD and GEPCZZ.                         */
/*       S01408 -  Addition of core hook SCCLRGL003                 */
/*                                       SCCLRGL004                 */
/*       S01408 -  Addition of core hook SCCLRGL001                 */
/*                                       SCCLRGL002                 */
/*       S01408 -  Addition of core hook SCCLRGLMPS                 */
/*       CRT001 -  Retail Teller System                             */
/*       S01413 -  Program use files which are no more use RE3      */
/*       S01421 -  Change for BLI step 1 development                */
/*                 Switchable feature S01423 - Customer Service     */
/*                 fees. Add new files to be cleared if that        */
/*                 feature is on the switchable features file       */
/*       048237 -  Remove processing for MC Module                  */
/*       S10736 -  Add processing for MC module.                    */
/*       S01340 -  REMOVE REDUNDANT GL FILES FROM PROGRAM           */
/*       S01343 -  SC/RR/SD MODULE RENAME PROJECT.                  */
/*                 - SCCLRGL RENAMED FROM SDCLRGL.                  */
/*       E15192 -  CLEAR GEXB* FILES                                */
/*       S01196 -  REMOVAL OF LETTERS OF CREDIT MODULE              */
/*       S01117 -  RELEASE 10 (MULTIBRANCHING)                      */
/*       S1101  -  NEW BSPL EXTRACT FILES.                          */
/*       S1102  -  INCLUSION OF AMOUNT ACCRUALS.                    */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,SCCLRGL011                                          */
             DCL        &MSG          TYPE(*CHAR)  LEN(75)
             DCL        VAR(&S01423) TYPE(*CHAR) LEN(7)               /*S01421*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*S01421*/
             DCL        VAR(&CRT001) TYPE(*CHAR) LEN(7)               /*CRT001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CMC001*/
/*/COPY WNCPYSRC,SCCLRGL006                                          */
/**/
             SNDPGMMSG  TOMSGQ(MRUNQ) +
                         MSG('Clear General Ledger Daily Files')
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCCLRGLMPS                                           /*S01408*/
/**/                                                                  /*S01408*/
/**/
             CLRPFM     FILE(ABEXHH)
             CLRPFM     FILE(ABEXAG)
/*           CLRPFM     FILE(ABEXAI)                        */        /*S01340*/
             CLRPFM     FILE(ABEXZY)
             CLRPFM     FILE(ACDETAA)
             CLRPFM     FILE(ACDETAB)
             CLRPFM     FILE(ACDETAC)
/*           CLRPFM     FILE(BSEXBBH)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXBHH)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXBZZ)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXHBH)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXHHH)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXHZZ)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXLBH)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXLHH)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXLZZ)                       */        /*S01101*/
/*           CLRPFM     FILE(BSEXBS)              */     /*S01340*/   /*S01101*/
/*           CLRPFM     FILE(BSEXPL)              */     /*S01340*/   /*S01101*/
/*           CLRPFM     FILE(BSEXCTL)             */     /*S01340*/   /*S01101*/
             CLRPFM     FILE(CLEAR2HH)
             CLRPFM     FILE(CLEAR2PD)
             CLRPFM     FILE(CLEAR2ZZ)
             CLRPFM     FILE(CLEAROHH)
             CLRPFM     FILE(CLEAROPD)
             CLRPFM     FILE(CLEAROZZ)
/************CLRPFM     FILE(EODPOHH)                       */        /*119873*/
/*/COPY WNCPYSRC,SCCLRGL007                                          */
/************CLRPFM     FILE(EODPOPD)                       */        /*119873*/
/*/COPY WNCPYSRC,SCCLRGL008                                          */
/************CLRPFM     FILE(EODPORA)                       */        /*119873*/
/************CLRPFM     FILE(EODPOZZ)                       */        /*119873*/
             CLRPFM     FILE(EXDAEA)
/*           CLRPFM     FILE(GEBCHH)                        */        /*S01196*/
/*           CLRPFM     FILE(GEBCPD)                        */        /*S01196*/
/*           CLRPFM     FILE(GEBCZZ)                        */        /*S01196*/
/*           CLRPFM     FILE(GEBXHH)                        */        /*S01196*/
/*           CLRPFM     FILE(GEBXPD)                        */        /*S01196*/
/*           CLRPFM     FILE(GEBXZZ)                        */        /*S01196*/
/*           CLRPFM     FILE(GEBC1HH)                       */        /*S01196*/
/*           CLRPFM     FILE(GEBC1PD)                       */        /*S01196*/
/*           CLRPFM     FILE(GEBC1ZZ)                       */        /*S01196*/
/*           CLRPFM     FILE(GEBX1HH)                       */        /*S01196*/
/*           CLRPFM     FILE(GEBX1PD)                       */        /*S01196*/
/*           CLRPFM     FILE(GEBX1ZZ)                       */        /*S01196*/
             CLRPFM     FILE(GECEHH)
             CLRPFM     FILE(GECEPD)
             CLRPFM     FILE(GECEZZ)
/*           CLRPFM     FILE(GEIC1HH)                       */        /*S01340*/
/*           CLRPFM     FILE(GEIC1PD)                       */        /*S01340*/
/*           CLRPFM     FILE(GEIC1ZZ)                       */        /*S01340*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCCLRGL001                                           /*S01408*/
/**/                                                                  /*S01408*/
             CLRPFM     FILE(GEIC2HH)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCCLRGL002                                           /*S01408*/
/**/                                                                  /*S01408*/
             CLRPFM     FILE(GEIC2PD)
             CLRPFM     FILE(GEIC2ZZ)
/*           CLRPFM     FILE(GEICAHH)                       */        /*S01340*/
/*           CLRPFM     FILE(GEICAPD)                       */        /*S01340*/
/*           CLRPFM     FILE(GEICAZZ)                       */        /*S01340*/
/*           CLRPFM     FILE(GEICCHH)                       */        /*S01413*/
/*           CLRPFM     FILE(GEICCPD)                       */        /*S01413*/
/*           CLRPFM     FILE(GEICCZZ)                       */        /*S01413*/
/*           CLRPFM     FILE(GEICHHH)                       */        /*S01340*/
/*           CLRPFM     FILE(GEICHPD)                       */        /*S01340*/
/*           CLRPFM     FILE(GEICHZZ)                       */        /*S01340*/
/*           CLRPFM     FILE(GEICOHH)                       */        /*S01340*/
/*           CLRPFM     FILE(GEICOPD)                       */        /*S01340*/
/*           CLRPFM     FILE(GEICOZZ)                       */        /*S01340*/
             CLRPFM     FILE(GEIERHH)
             CLRPFM     FILE(GEIERPD)
             CLRPFM     FILE(GEIERZZ)
             CLRPFM     FILE(GESOHH)
             CLRPFM     FILE(GESOPD)
             CLRPFM     FILE(GESOZZ)
             CLRPFM     FILE(GESFPD)                                  /*121058*/
             CLRPFM     FILE(GESFZZ)                                  /*121058*/
             CLRPFM     FILE(GESF2PD)                                 /*121058*/
             CLRPFM     FILE(GESF2ZZ)                                 /*121058*/
             CLRPFM     FILE(GEXFHH)
             CLRPFM     FILE(GEXFPD)
             CLRPFM     FILE(GEXFZZ)
             CLRPFM     FILE(GEXBHH)                                  /*E15192*/
             CLRPFM     FILE(GEXBPD)                                  /*E15192*/
             CLRPFM     FILE(GEXBZZ)                                  /*E15192*/
             CLRPFM     FILE(GL0781EX)                                /*S01117*/
             CLRPFM     FILE(GLEXHH)
             CLRPFM     FILE(GLEXGC)
             CLRPFM     FILE(GLEXZY)
             CLRPFM     FILE(GLX05)
             CLRPFM     FILE(GLX07)
             CLRPFM     FILE(GLX09)
             CLRPFM     FILE(GLX14)
             CLRPFM     FILE(GLX16)
             CLRPFM     FILE(GLX18)
             CLRPFM     FILE(MANPOHH)
             CLRPFM     FILE(MANPOPD)
             CLRPFM     FILE(MANPOZZ)
/*/COPY WNCPYSRC,SCCLRGL009                                          */
             CLRPFM     FILE(RCHGHH)
             CLRPFM     FILE(RCHGRA)
             CLRPFM     FILE(RCHGZZ)
             CLRPFM     FILE(STMTHH)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCCLRGL003                                           /*S01408*/
/**/                                                                  /*S01408*/
             CLRPFM     FILE(STMTAH)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCCLRGL004                                           /*S01408*/
/**/                                                                  /*S01408*/
             CLRPFM     FILE(STMTZX)
             CLRPFM     FILE(SYSOPHH)
             CLRPFM     FILE(SYSOPAJ)
             CLRPFM     FILE(SYSOPZX)
/*           CLRPFM     FILE(VALUEHH)                    */           /*S01340*/
/*           CLRPFM     FILE(VALUEPD)                    */           /*S01340*/
/*           CLRPFM     FILE(VALUERA)                    */           /*S01340*/
/*           CLRPFM     FILE(VALUEZZ)                    */           /*S01340*/
/**/
             CLRPFM     FILE(AMAEXA)                                /* S1102 */
             CLRPFM     FILE(AMAEXD)                                /* S1102 */
             CLRPFM     FILE(AMAEXZ)                                /* S1102 */
             CLRPFM     FILE(GEAAPD)                                /* S1102 */
             CLRPFM     FILE(GEAAZZ)                                /* S1102 */
             CLRPFM     FILE(NAMACA)                                /* S1102 */
             CLRPFM     FILE(NAMACD)                                /* S1102 */
             CLRPFM     FILE(NAMACZ)                                /* S1102 */
             CLRPFM     FILE(GEAA2HH)                               /* 122794*/
             CLRPFM     FILE(GEAA2PD)                               /* 122794*/
             CLRPFM     FILE(GEAA2ZZ)                               /* 122794*/
/*/COPY WNCPYSRC,SCCLRGL010                                          */
/************                                               /*S10736* *048237*/
/************DLTF       FILE(GLPOSTL5X)                     /*S10736* *048237*/
/************MONMSG     MSGID(CPF2105)                      /*S10736* *048237*/
/************                                               /*S10736* *048237*/
/**/
/**/
/* Check to see if the customer service fees switchable feature */    /*S01421*/
/* is present in the system and only clear the Hold Mail and    */    /*S01421*/
/* Numbered Account files if the feature is on                  */    /*S01421*/
/**/                                                                  /*S01421*/
             CALL       PGM(AOSARDR0) PARM(&S01423 '*VERIFY' +
                          'S01423' &AOFMT)                            /*S01421*/
/**/                                                                  /*S01421*/
/* Clear Hold Mail and Numbered Accounts files */                     /*S01421*/
/**/                                                                  /*S01421*/
             IF         COND(&S01423 *EQ ' ') THEN(DO)                /*S01421*/
                CLRPFM     FILE(GEHMPD)                               /*S01421*/
                CLRPFM     FILE(GEHMZZ)                               /*S01421*/
                CLRPFM     FILE(GENAPD)                               /*S01421*/
                CLRPFM     FILE(GENAZZ)                               /*S01421*/
                CLRPFM     FILE(GEHM2PD)                              /*S01421*/
                CLRPFM     FILE(GEHM2ZZ)                              /*S01421*/
                CLRPFM     FILE(GENA2PD)                              /*S01421*/
                CLRPFM     FILE(GENA2ZZ)                              /*S01421*/
             ENDDO                                                    /*S01421*/
/**/
/* Check to see if Retail Teller System is on                   */    /*CRT001*/
/**/                                                                  /*CRT001*/
             CALL       PGM(AOSARDR0) PARM(&CRT001 '*VERIFY' +
                          'CRT001' &AOFMT)                            /*CRT001*/
/**/                                                                  /*CRT001*/
/* Clear Retail Teller System Files                             */    /*CRT001*/
/**/                                                                  /*CRT001*/
             IF         COND(&CRT001 *EQ ' ') THEN(DO)                /*CRT001*/
                        CLRPFM     FILE(GETTPH)                       /*CRT001*/
                        CLRPFM     FILE(GETTPD)                       /*CRT001*/
                        CLRPFM     FILE(GETTPZ)                       /*CRT001*/
                        CLRPFM     FILE(TTIBPH)                       /*CRT001*/
                        CLRPFM     FILE(TTIBPD)                       /*CRT001*/
                        CLRPFM     FILE(TTIBPZ)                       /*CRT001*/
             ENDDO                                                    /*CRT001*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCCLRGL005                                           /*S01408*/
/**/                                                                  /*S01408*/
/**/                                                                  /*CMC001*/
/* Check to see if Management Accounts Enhancement feature is on */   /*CMC001*/
/**/                                                                  /*CMC001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CMC001' &AOFMT)                            /*CMC001*/
/**/                                                                  /*CMC001*/
/* Clear Management Accounts Daily Files                        */    /*CMC001*/
/**/                                                                  /*CMC001*/
/*/COPY WNCPYSRC,SCH00046                                            */
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CMC001*/
                CLRPFM     FILE(GEPCPD)                               /*CMC001*/
                CLRPFM     FILE(GEPCZZ)                               /*CMC001*/
/**/                                                                  /*127963*/
                CLRPFM     FILE(MCACHBPD)                             /*127963*/
                CLRPFM     FILE(MCBLEXPD)                             /*127963*/
                CLRPFM     FILE(MCBLRPPD)                             /*127963*/
                CLRPFM     FILE(MCFMVMPD)                             /*127963*/
                CLRPFM     FILE(MCFREXPD)                             /*127963*/
/***************CLRPFM     FILE(MCGAP1PD)                  /*127963*/ /*135055*/
/***************CLRPFM     FILE(MCGEXTPD)                  /*127963*/ /*135055*/
                CLRPFM     FILE(MCHIBLPD)                             /*127963*/
                CLRPFM     FILE(MCMOVEPD)                             /*127963*/
                CLRPFM     FILE(MCPCACPD)                             /*127963*/
                CLRPFM     FILE(MCPCBLPD)                             /*127963*/
                CLRPFM     FILE(MCPOSTPD)                             /*127963*/
                CLRPFM     FILE(MCPST1PD)                             /*127963*/
                CLRPFM     FILE(MCPST2PD)                             /*127963*/
                CLRPFM     FILE(MCPST3PD)                             /*127963*/
                CLRPFM     FILE(MCSRRPOQ)                             /*127963*/
             ENDDO                                                    /*CMC001*/
/**/                                                                  /*CRE004*/
/* Check to see if Sweep Accounting Feature is switched ON */         /*CRE004*/
/**/                                                                  /*CRE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CRE004' &AOFMT)                            /*CRE004*/
/**/                                                                  /*CRE004*/
/* Clear Sweep Accounting Daily Files                           */    /*CRE004*/
/**/                                                                  /*CRE004*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CRE004*/
                CLRPFM     FILE(GESPPD)                               /*CRE004*/
                CLRPFM     FILE(GESPZZ)                               /*CRE004*/
                CLRPFM     FILE(GESP2PD)                              /*CRE004*/
                CLRPFM     FILE(GESP2ZZ)                              /*CRE004*/
             ENDDO                                                    /*CRE004*/
                                                                                          /*CGL030*/
/* Check for enhancement enabled                                 */                       /*CGL030*/
             CALL       PGM(AOSARDR0) PARM(&RTCD  '*VERIFY' +
                          'CGL030' &AOFMT)                                                /*CGL030*/
                                                                                          /*CGL030*/
/* If enabled, clear */                                                                   /*CGL030*/
         IF        COND(&RTCD  *EQ '       ') THEN(DO)                                    /*CGL030*/
             CLRPFM     FILE(GESUPD)                                                      /*CGL030*/
             CLRPFM     FILE(GESUHH)                                                      /*CGL030*/
             CLRPFM     FILE(GESUZZ)                                                      /*CGL030*/
             CLRPFM     FILE(GESU2PD)                                                     /*CGL030*/
             CLRPFM     FILE(GESU2HH)                                                     /*CGL030*/
             CLRPFM     FILE(GESU2ZZ)                                                     /*CGL030*/
             CLRPFM     FILE(GESU3PD)                                                     /*CGL030*/
             CLRPFM     FILE(GESU3HH)                                                     /*CGL030*/
             CLRPFM     FILE(GESU3ZZ)                                                     /*CGL030*/
             CLRPFM     FILE(GLSUNDPD)                                                    /*CGL030*/
         ENDDO                                                                            /*CGL030*/
/**/                                                                  /*CEU013*/
/* Check to see if A/C Posting Narrative feature is ON     */         /*CEU013*/
/**/                                                                  /*CEU013*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CEU013' &AOFMT)                            /*CEU013*/
/**/                                                                  /*CEU013*/
/* Clear GL Daily Files                                    */         /*CEU013*/
/**/                                                                  /*CEU013*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CEU013*/
                CLRPFM     FILE(MANPOAPD)                             /*CEU013*/
             ENDDO                                                    /*CEU013*/
                                                                                          /*CRE026*/
/** Check to see if Consumer Banking CRE026 is switched ON */                             /*CRE026*/
                                                                                          /*CRE026*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CRE026' &AOFMT)                                                /*CRE026*/
                                                                                          /*CRE026*/
/***Clear*Consumer*Banking*Posting*Daily*Files**********************/              /*CRE026 CSC056*/
                                                                                          /*CRE026*/
/**********  IF         COND(&RTCD *EQ ' ') THEN(DO)               */              /*CRE026 CSC056*/
/**********     CLRPFM     FILE(GECBPD)                            */              /*CRE026 CSC056*/
/**********     CLRPFM     FILE(GECBZZ)                            */              /*CRE026 CSC056*/
/**********     CLRPFM     FILE(GECB2PD)                           */              /*CRE026 CSC056*/
/**********     CLRPFM     FILE(GECB2ZZ)                           */              /*CRE026 CSC056*/
/**********  ENDDO                                                 */              /*CRE026 CSC056*/
                                                                                          /*CRE026*/
/**/                                                                  /*186206*/
/* Clear Today's Batch Numbers Used file                   */         /*186206*/
/**/                                                                  /*186206*/
/**********  CLRPFM     FILE(GLBTNOPD)  */                                         /*186206 236369*/
                                                                                          /*CGL047*/
/* Clear files used by CGL047                                                             /*CGL047*/
             CLRPFM     FILE(GEGPIHH)                                                     /*CGL047*/
             CLRPFM     FILE(GEGPIHH)                                                     /*CGL047*/
             CLRPFM     FILE(GEGPIZZ)                                                     /*CGL047*/
                                                                                          /*236189*/
             CLRPFM     FILE(AOSPOSPD)                                                    /*236189*/
/**/                                                                                      /*CAP204*/
/* Check to see if Teller Related APIs - Account Transfer is ON */                        /*CAP204*/
/**/                                                                                      /*CAP204*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CAP204' &AOFMT)
/**/                                                                                      /*CAP204*/
/* Clear GL files for Account Transfer details                  */                        /*CAP204*/
/**/                                                                                      /*CAP204*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                                      /*CAP204*/
             CLRPFM     FILE(GETXHH)                                                      /*CAP204*/
             CLRPFM     FILE(GETXPD)                                                      /*CAP204*/
             CLRPFM     FILE(GETXZZ)                                                      /*CAP204*/
             CLRPFM     FILE(GETX2HH)                                                     /*CAP204*/
             CLRPFM     FILE(GETX2PD)                                                     /*CAP204*/
             CLRPFM     FILE(GETX2ZZ)                                                     /*CAP204*/
             ENDDO                                                                        /*CAP204*/
 
             SNDPGMMSG  TOMSGQ(MRUNQ) +
                               MSG('General Ledger Daily Files Cleared')
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM     /* END CL PGM */
