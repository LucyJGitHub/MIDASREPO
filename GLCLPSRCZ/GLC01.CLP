/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas GL Next day set up')                            */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                         */
/*                                                                  */
/*       GLC01 - NEXT DAY SETUP                                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD026439           Date 24Apr14              */
/*       Prev Amend No. AR1096788          Date 18Mar13              */
/*                      AR1005423          Date 09Aug12              */
/*                      AR1018468          Date 20Oct12              */
/*                      AR999702           Date 05Jul12              */
/*                      263384             Date 22Jan10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CRE005            Date  18Jan10             */
/*                      CCB016            Date  30Nov05             */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      236369             Date 04Jan06             */
/*                      CER001             Date 25Apr05              */
/*                      BUG5919            Date 23Feb05             */
/*                      CDL026             Date 12Nov04             */
/*                      CGL013             Date 20Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009             Date 18Mar99             */
/* Midas DBA 3.00 ---------------- Base ----------------------------*/
/*                      CGL008            Date 03Mar99              */
/*                      S01408            Date 30Oct95              */
/*                      S01408            Date 05Sep95              */
/*                      S01408            DATE  12JAN95             */
/*                      S01340            DATE  06AUG91             */
/*                      DT0072            DATE  02MAY91             */
/*                      S01229 (S01251)   DATE  04APR90             */
/*                      S01234            DATE  14FEB90             */
/*                      S01117            DATE  09/05/89            */
/*                      S01154            DATE  24/08/88            */
/*                      E12073            DATE  08/03/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD026439 - Field tag 61 Posting Date of the generated      */
/*                  MT940 for Subsidiary Account is incorrect       */
/*                  Added hook: CGL146_147                          */
/*       AR1096788 - DLAA details should be written in core STRANF  */
/*                   file instead of the new DLSTRANFPD file        */
/*       AR1005423 - STRAN Limitation. Need to modify programs      */
/*                   updating STRAN header and detail records,      */
/*                   from update to write record to STRAN.          */
/*                   Set Initialize PFM of STRAN to 1 record only   */
/*                   after clearing the file. (Child: AR900145)     */
/*       AR1018468 - UDF Historical files (Child:AR1018470)          */
/*       AR999702 - Insert of corrective batch in Live with batch   */
/*                  number in PEA displays an error                 */
/*       263384 - Batch Input Error. Applied fixes 249259/251718 w/c */
/*                deletes the Journal Entry Extension file table.    */
/*       CRE005 - Changes to STRAN                                  */
/*       CCB016 - CoB Performance Enhancements                      */
/*                No need to copy data from GLJEH* files to QTEMP.  */
/*       236369 - Move clearing of GLBTNOPD here from SCCLRGL.      */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*   BUG5919- Amend INZPFM to RGZPFM                                */
/*   CDL026 - Authorisation on Dealing Accrued Interest Adjustments */
/*       CGL013 - MT94x Message Generation.                          */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and    */
/*                Third Party Payments (TPP) Interface              */
/*       CGL008 - Security on Journal Entry. Recompile.             */
/*       S01408 - ADDITION OF CORE HOOK GLC01002                    */
/*       S01408 - ADDITION OF CORE HOOK GLC01001                    */
/*       S01408 - ADDITION OF CORE HOOK GLC01INT                    */
/*                ADDITION OF CORE HOOK GLC01MPS                    */
/*                                                                  */
/*       S01340 - MIS RELEASE 10 - BATCH RETENTION                  */
/*                                                                  */
/*       DT0072 - STRANF AND STRANH NEED TO BE INITIALISED          */
/*                                                                  */
/*       S01251 - SYNON PROGRAM/FILE/FIELD NAME CHANGES             */
/*                                                                  */
/*       S01229 - SYNON FILE NAME CHANGES                           */
/*                                                                  */
/*       S01234 - JOURNAL ENTRY TEMPLATE ENHANCEMENTS               */
/*                BATCH INTERFACE FILES ARE REQUIRED TO BE CLEARED  */
/*                                                                  */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/*       S01154 - CHANGES FOR NEW GENERAL LEDGER : NEW FILE         */
/*                                                                  */
/*       E12073 - BTRAN FILE SIZE CHANGE THROUGH ICD MAINTENANCE    */
/*                TRANSFERRED TO GLSTAT FOR ACTION                  */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&INCREASE) TYPE(*DEC)  LEN(5)
/*/COPY WNCPYSRC,GLC01004                                            */
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CGL009*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CGL009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CGL013*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CGL013*/
             DCL        VAR(&CGL013) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGL013*/
             DCL        VAR(&CDL026) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CDL026*/
/**********  DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                */        /*263384 AR1018468*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC01INT                                     */      /*S01408*/
             DCL        VAR(&UPL053) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CER001*/
             DCL        VAR(&ULX043) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CER001*/
/**/                                                                                      /*CER001*/
/** Check if Automatic Batches acceptance is installed. */                                /*CER001*/
/**/                                                                                      /*CER001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER001*/
             CHGVAR     VAR(&SAR) VALUE('UPL053')                                         /*CER001*/
/**/                                                                                      /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &FMT)                         /*CER001*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&UPL053) VALUE('Y'))                                          /*CER001*/
/**/                                                                                      /*CER001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER001*/
             CHGVAR     VAR(&SAR) VALUE('ULX043')                                         /*CER001*/
                                                                                          /*CER001*/
/** Check whether fetaure IBLC 2002 Reporting is present. */                              /*CER001*/
                                                                                          /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &FMT)                         /*CER001*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&ULX043) VALUE('Y'))                                          /*CER001*/
/**/
             SNDPGMMSG  MSG(' General Ledger next day set up') +
                          TOMSGQ(MRUNQ)
                                                                                          /*CGL013*/
/* Clear file GLBTNOPD */                                                                 /*236369*/
             CLRPFM     FILE(GLBTNOPD)                                                    /*236369*/
                                                                                          /*236369*/
/*/COPY WNCPYSRC,GLH00706                                            */
/** Check for Switchable feature CDL026 */                                                /*CDL026*/
                                                                                          /*CDL026*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL026*/
             CHGVAR     VAR(&SAR) VALUE('CDL026')                                         /*CDL026*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                                           &FMT)                                          /*CDL026*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL026) VALUE('Y'))                                        /*CDL026*/
             IF         COND(&CDL026 *EQ 'Y') THEN(DO)                                    /*CDL026*/
             CALL       PGM(GL0055)                                                       /*CDL026*/
/*********** INZPFM     FILE(DLAIAUPD)                                             /*CDL026BUG5919*/
                 CALL       PGM(SCC000060) PARM('DLAIAUPD' '*FIRST')                     /*BUG5919*/
             ENDDO                                                                        /*CDL026*/
/*           OVRDBF     FILE(TABLE)  TOFILE(TABGL)                     S01117 */
/**/
             CLRPFM     FILE(STRAN)
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
             CHGVAR     VAR(&INCREASE) VALUE(%SUBSTRING(&GLSTAT 26 5   ))
/**********  INZPFM     FILE(STRAN)  TOTRCDS(&INCREASE)*/                              /*AR1005423*/
             INZPFM     FILE(STRAN)  TOTRCDS(1)                                        /*AR1005423*/
/**********  CLRPFM     FILE(DLSTRANFPD)                                  */ /*AR1005423 AR1096788*/
             CLRPFM     FILE(STRANF)                       /*DT0072*/
             CLRPFM     FILE(STRANH)                       /*DT0072*/
             INZPFM     FILE(STRANF)  TOTRCDS(&INCREASE)   /*DT0072*/
             CLRPFM     FILE(RERCHHPA)                                                    /*CRE005*/
             CLRPFM     FILE(RERCH1PD)                                                    /*CRE005*/
             CLRPFM     FILE(RERCH2PD)                                                    /*CRE005*/
             CLRPFM     FILE(RERCH3PD)                                                    /*CRE005*/
/**/
/*/COPY WNCPYSRC,GLC01002                                     */      /*S01408*/
/**/
/**********  CALL       PGM(GL0940)                     */ /*E12073*/ /*S01117*/
/**/                                                                  /*E12073*/
/*           CLRPFM     FILE(BTRAN)                        */         /*S01154*/
/*           RCVDTAARA  DTAARA(GLSTAT)                     */         /*S01154*/
/*  CHGVAR   VAR(&INCREASE) VALUE(%SUBSTRING(&GLSTAT 11 5))*/         /*S01154*/
/*           INZPFM     FILE(BTRAN)  TOTRCDS(&INCREASE)    */         /*S01154*/
/**/                                                                  /*S01154*/
/************CLRPFM GLBRREP*/                              /*S01229*/ /*S01154*/
/************CLRPFM GLBSREP*/                              /*S01229*/ /*S01154*/
/************CLRPFM GLBTREP*/                              /*S01229*/ /*S01154*/
 
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC01001                                     */      /*S01408*/
                                                                                          /*CER001*/
/** When feature IBLC 2002 is installed, ensure Ext. file is cleared. */                  /*CER001*/
                                                                                          /*CER001*/
             IF         COND(&ULX043 *EQ 'Y') THEN(DO)                                    /*CER001*/
             CLRPFM     FILE(GLJPX1PD)                                                    /*CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                                          /*CER001*/
/**/                                                                  /*S01408*/
                                                                                          /*CGL013*/
/** Check for Switchable feature CGL013 */                                                /*CGL013*/
                                                                                          /*CGL013*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGL013*/
             CHGVAR     VAR(&SAR) VALUE('CGL013')                                         /*CGL013*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                                           &FMT)                                          /*CGL013*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL013) VALUE('Y'))                                        /*CGL013*/
/**/                                                                  /*S01340*/
/* TRANSFER BATCH ENTRIES TO HISTORY FILES                            /*S01340*/
/**/                                                                  /*S01340*/
/*********** CPYF       FROMFILE(GLJEHHPD) TOFILE(QTEMP/XGLJEHHPD) +                        CCB016*/
/***********              MBROPT(*ADD) CRTFILE(*YES)                           /*S01340*/ /*CCB016*/
/*********** CPYF       FROMFILE(GLJEHPPD) TOFILE(QTEMP/XGLJEHPPD) +                        CCB016*/
/***********              MBROPT(*ADD) CRTFILE(*YES)                           /*S01340*/ /*CCB016*/
/*********** CPYF       FROMFILE(GLJEHSPD) TOFILE(QTEMP/XGLJEHSPD) +                        CCB016*/
/***********              MBROPT(*ADD) CRTFILE(*YES)                           /*S01340*/ /*CCB016*/
                                                                                          /*CGL013*/
/** If CGL013 is installed, additional information is transferred  */                     /*CGL013*/
/** to its corresponding Historic File as well.                    */                     /*CGL013*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 *EQ 'Y') THEN(DO)                                    /*CGL013*/
/***************CPYF       FROMFILE(GLJEHXPD) TOFILE(QTEMP/XGLJEHXPD) +
                             MBROPT(*ADD) CRTFILE(*YES)                        /*CGL013*/ /*CCB016*/
             ENDDO                                                                        /*CGL013*/
                                                                                          /*CGL013*/
/**/                                                                  /*S01340*/
/*/COPY WNCPYSRC,GLC01005                                            */
/*********** CLRPFM     FILE(QTEMP/XGLJEHHPD)                                  /*S01340*/ /*CCB016*/
/*********** CLRPFM     FILE(QTEMP/XGLJEHPPD)                                  /*S01340*/ /*CCB016*/
/*********** CLRPFM     FILE(QTEMP/XGLJEHSPD)                                  /*S01340*/ /*CCB016*/
             CRTDUPOBJ  OBJ(GLJEHHPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(XGLJEHHPD) DATA(*NO)                        /*CCB016*/
             CRTDUPOBJ  OBJ(GLJEHPPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(XGLJEHPPD) DATA(*NO)                        /*CCB016*/
             CRTDUPOBJ  OBJ(GLJEHSPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(XGLJEHSPD) DATA(*NO)                        /*CCB016*/
                                                                                          /*CCB016*/
             OVRDBF     FILE(GLJEHHPD) TOFILE(QTEMP/XGLJEHHPD)        /*S01340*/
             OVRDBF     FILE(GLJEHPPD) TOFILE(QTEMP/XGLJEHPPD)        /*S01340*/
             OVRDBF     FILE(GLJEHSPD) TOFILE(QTEMP/XGLJEHSPD)        /*S01340*/
                                                                                          /*CGL013*/
/** If CGL013 is installed, */                                                            /*CGL013*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 *EQ 'Y') THEN(DO)                                    /*CGL013*/
/*********** CLRPFM     FILE(QTEMP/XGLJEHXPD)                         /*CGL013*/          /*CCB016*/
             CRTDUPOBJ  OBJ(GLJEHXPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(XGLJEHXPD) DATA(*NO)                        /*CCB016*/
                OVRDBF     FILE(GLJEHXPD) TOFILE(QTEMP/XGLJEHXPD)                         /*CGL013*/
             ENDDO                                                                        /*CGL013*/
                                                                                          /*CGL013*/
/**/                                                                  /*S01340*/
             CALL       PGM(GL2560)                                   /*S01340*/
             DLTOVR     FILE(GLJEHHPD GLJEHPPD GLJEHSPD)              /*S01340*/
                                                                                          /*CGL013*/
/** If CGL013 is installed, */                                                            /*CGL013*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 *EQ 'Y') THEN(DO)                                    /*CGL013*/
                DLTOVR     FILE(GLJEHXPD)                                                 /*CGL013*/
             ENDDO                                                                        /*CGL013*/
                                                                                          /*CGL013*/
/*/COPY WNCPYSRC,GLC01007                                            */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO END)        /*S01340*/
/**/                                                                  /*S01340*/
             CPYF       FROMFILE(QTEMP/XGLJEHHPD) TOFILE(GLJEHHPD) +
                          MBROPT(*ADD)                                /*S01340*/
             MONMSG     MSGID(CPF2972)                                /*S01340*/
             CPYF       FROMFILE(QTEMP/XGLJEHPPD) TOFILE(GLJEHPPD) +
                          MBROPT(*ADD)                                /*S01340*/
             MONMSG     MSGID(CPF2972)                                /*S01340*/
             CPYF       FROMFILE(QTEMP/XGLJEHSPD) TOFILE(GLJEHSPD) +
                          MBROPT(*ADD)                                /*S01340*/
             MONMSG     MSGID(CPF2972)                                /*S01340*/
                                                                                          /*CGL013*/
/** If CGL013 is installed, */                                                            /*CGL013*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 *EQ 'Y') THEN(DO)                                    /*CGL013*/
                CPYF       FROMFILE(QTEMP/XGLJEHXPD) TOFILE(GLJEHXPD) +
                             MBROPT(*ADD)                                                 /*CGL013*/
                MONMSG     MSGID(CPF2972)                                                 /*CGL013*/
             ENDDO                                                                        /*CGL013*/
/*                                                                 */ /*S01340*/
/*/COPY WNCPYSRC,GLC01003                                            */
             CLRPFM GLJENHPD                               /*S01229*/ /*S01154*/
             CLRPFM GLJENSPD                               /*S01229*/ /*S01154*/
             CLRPFM GLJENPPD                               /*S01229*/ /*S01154*/
/*/COPY OFCPYSRCZ,CGL146_147                                         */                 /*MD026439*/
             CLRPFM GLJENHQD                                                            /*AR999702*/
             CLRPFM GLJENPQD                                                            /*AR999702*/
                                                                                          /*CGL013*/
/** If CGL013 is installed, */                                                            /*CGL013*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 *EQ 'Y') THEN(DO)                                    /*CGL013*/
                CLRPFM GLJENXPD                                                           /*CGL013*/
             ENDDO                                                                        /*CGL013*/
/**/                                                                  /*S01154*/
/* CLEAR BATCH INTERFACE FILES ( HEADER AND POSTINGS )                /*S01234*/
/**/                                                                  /*S01234*/
/************CLRPFM GLBTIFP*/                              /*S01229*/ /*S01234*/
/************CLRPFM GLBPIFP*/                              /*S01229*/ /*S01234*/
                                                                      /*S01229*/
             CLRPFM GLJEIHPD                               /*S01229*/ /*S01234*/
/*/COPY WNCPYSRC,GLC01006                                            */
             CLRPFM GLJEIPPD                               /*S01229*/ /*S01234*/
                                                                                          /*CGL013*/
/** If CGL013 is installed, clear GL Journal Entry Interface file - */                    /*CGL013*/
/** Additional Information */                                                             /*CGL013*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 *EQ 'Y') THEN(DO)                                    /*CGL013*/
                CLRPFM GLJEIXPD                                                           /*CGL013*/
             ENDDO                                                                        /*CGL013*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC01MPS                                     */      /*S01408*/
                                                                                          /*CER001*/
/** When feature IBLC 2002 is installe , ensure Ext. file is cleared. */                  /*CER001*/
                                                                                          /*CER001*/
             IF         COND(&ULX043 *EQ 'Y') THEN(DO)                                    /*CER001*/
             CLRPFM     FILE(GLJIX1PD)                                                    /*CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                                          /*CER001*/
             IF COND(&UPL053 *EQ 'Y') THEN(DO)                                            /*CER001*/
             CLRPFM TOJEXHPD                                                              /*CER001*/
             CLRPFM TOJEXPPD                                                              /*CER001*/
             ENDDO                                                                        /*CER001*/
/**/                                                                  /*S01408*/
/***Delete*Journal*Entry*UDF*Extension*Table*for*Zone*****************/         /*263384 AR1018468*/
/**********  CALL       PGM(GL000020) PARM(&PRTCD)                   */         /*263384 AR1018468*/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO END)       */         /*263384 AR1018468*/
                                                                      /*S01229*/
/*/COPY WNCPYSRC,GLH00806                                            */
             CALL       PGM(GL0900)
/*           DLTOVR     FILE(TABLE)                                     S01117*/
/**/                                                                  /*CGL009*/
/*    If CGL009 active, reset IAT/TPP dtaara ready for next day       /*CGL009*/
/**/                                                                  /*CGL009*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CGL009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL009' +
                          &FMT)                                       /*CGL009*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CGL009*/
             CALL       PGM(GLC2830)                                  /*CGL009*/
             ENDDO                                                    /*CGL009*/
/**/                                                                  /*CGL009*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*           ENDPGM          */                                       /*S01340*/
END:         ENDPGM                                                   /*S01340*/
