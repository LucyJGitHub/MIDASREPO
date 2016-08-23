/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Set-up recovery journal file')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Restart Recovery Module.                            */
/*                                                                   */
/*       RRC1730 - Setup journalling file ready for conversion       */
/*                 to PF/JRNFIL format.                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Last Amend No. CPB001             Date 15Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPL002             DATE 08MAR99              */
/*                      S01408             DATE 08SEP93              */
/*                      087083             DATE 04MAY95              */
/*                      082565             DATE 01FEB95              */
/*                      S01498             DATE 10JUN94              */
/*                      S01486             DATE 10JUN94              */
/*                      S01522             DATE 25NOV94              */
/*                      S01493             DATE 31MAY94              */
/*                      053823             DATE 08NOV93              */
/*                      S01407             DATE 04FEB93              */
/*                      S01379             DATE 22SEP92              */
/*                      S01319             DATE 17JAN92              */
/*                      E34675             DATE 17JAN92              */
/*                      S01345             DATE 24OCT91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPB001 - Private Banking Module                             */
/*       CPL002 - MIDAS-PLATO INTERFACE                              */
/*       S01408 - Core Hook Added - RRC1730001                       */
/*              - Core Hook Added - RRC1730002                       */
/*              - Core Hook Added - RRC1730003                       */
/*              - Core Hook Added - RRC1730004                       */
/*       087083 - NOT JOURNALLING LB CORRECTLY                       */
/*       082565 - SCJRN* logical files are now redundant.            */
/*       S01498 - PORTFOLIO LENDING (LOMBARD CREDITS)                */
/*       S01486 - PORTFOLIO MANAGEMENT                               */
/*       S01522 - User Defined Correspondence                        */
/*       S01493 - MIDAS EXPORT DATA MODULE ADDED                     */
/*       053823 - CPYF TO QTEMP/RR1730 SHOULD BE *ADD, NOT *REPLACE. */
/*                ORIGINALLY ENTERED UNDER S01407. REINSTATE AS      */
/*                053823.                                            */
/*       S01407 - SWITCHABILITY ENHANCEMENTS                         */
/*                ADDITION OF 'SS' MODULE                            */
/*       S01379 - HAF HISTORY AND AUDIT FACILITY                     */
/*                ADDITION OF 'HF' MODULE                            */
/*       S01319 - Project HARRY.                                     */
/*              - Remove processing for modules CM, FD, FX and MM.   */
/*       E34675 - The SD module has significantly more data to       */
/*                process than any other module and is always the    */
/*                last to complete by a long period. The SD data     */
/*                has now been split into SD (SD prefixed SD files)  */
/*                and S1 (non-SD prefixed SD files).                 */
/*       S01345 - Midas journalling system re-write.                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FAIL) TYPE(*CHAR) LEN(20)
 
/*  Clear down PF/RRC1730  */
 
             DLTF       FILE(QTEMP/RRC1730)
             MONMSG     MSGID(CPF0000)
 
/*  Access PF/SDMMODPD to determine which modules are live  */
 
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
/*  Database error handling  */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
               SNDPGMMSG  MSG('Error on access to ICD file +
                            AOMMODPD') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
                                                                      /*082565*/
/*  Create the work file in the correct format */                     /*082565*/
                                                                      /*082565*/
             CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*082565*/
                                                                      /*082565*/
/*  SD is always present - therefore copy the SD records */
/*  and the S1 records                                   */           /*E34675*/
 
/**********  CPYF       FROMFILE(SCJRNSD) TOFILE(QTEMP/RR1730) +      /*082565*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES)              /*082565*/
             CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                          MBROPT(*REPLACE) INCREL((*IF MOD *EQ +
                          'SD') (*OR MOD *EQ 'S1')) +
                          FMTOPT(*MAP *DROP)                          /*082565*/
             MONMSG     MSGID(CPF0000)
 
/*********** CPYF       FROMFILE(SCJRNS1) TOFILE(QTEMP/RR1730) +
                          MBROPT(*REPLACE) CRTFILE(*YES)*/ /*E34675*/ /*053832*/
/*********** CPYF       FROMFILE(SCJRNS1) TOFILE(QTEMP/RR1730) +      /*082565*/
/***********              MBROPT(*ADD)                                /*053823*/
             MONMSG     MSGID(CPF0000)                                /*E34675*/
                                                                      /*E34675*/
/*  SS (Switchable SARS) is always present - therefore copy SS recs*/ /*S01407*/
                                                                      /*S01407*/
/*********** CPYF       FROMFILE(SCJRNSS) TOFILE(QTEMP/RR1730) +      /*082565*/
/***********              MBROPT(*ADD)                     /*S01407*/ /*082565*/
             CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                          MBROPT(*ADD) INCREL((*IF MOD *EQ 'SS')) +
                          FMTOPT(*MAP *DROP)                          /*082565*/
             MONMSG     MSGID(CPF0000)                                /*S01407*/
                                                                      /*S01407*/
/*  FC is always present - therefore copy the FC records */
 
/*********** CPYF       FROMFILE(SCJRNFC) TOFILE(QTEMP/RR1730) +      /*082565*/
/***********              MBROPT(*ADD)                                /*082565*/
             CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                          MBROPT(*ADD) INCREL((*IF MOD *EQ 'FC')) +
                          FMTOPT(*MAP *DROP)                          /*082565*/
             MONMSG     MSGID(CPF0000)
 
/*  GL is always present - therefore copy the GL records */
 
/*********** CPYF       FROMFILE(SCJRNGL) TOFILE(QTEMP/RR1730) +      /*082565*/
/***********              MBROPT(*ADD)                                /*082565*/
             CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                          MBROPT(*ADD) INCREL((*IF MOD *EQ 'GL')) +
                          FMTOPT(*MAP *DROP)                          /*082565*/
             MONMSG     MSGID(CPF0000)
 
/*  Local Module is always present - therefore copy the XX records */
 
/*********** CPYF       FROMFILE(SCJRNXX) TOFILE(QTEMP/RR1730) +      /*082565*/
/***********              MBROPT(*ADD)                                /*082565*/
             CPYF       FROMFILE(SCJRNXXPD) TOFILE(QTEMP/RR1730) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)             /*082565*/
             MONMSG     MSGID(CPF0000)
 
/*  If EM is present - copy the EM records */
 
             IF         COND(%SST(&FMT 25 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNEM) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'EM')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If LE is present - copy the LE records */
 
             IF         COND(%SST(&FMT 28 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNLE) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'LE')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If RE is present - copy the RE records */
 
             IF         COND(%SST(&FMT 29 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNRE) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'RE')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If PM is present - copy the PM records */                         /*S01486*/
                                                                      /*S01486*/
             IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO)        /*S01486*/
/**********     CPYF       FROMFILE(SCJRNPM) TOFILE(QTEMP/RR1730) +   /*082565*/
/**********                  MBROPT(*ADD)                  /*S01486*/ /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'PM')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)                             /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*CPB001*/
/*  If PB is present - copy the PB records */                         /*CPB001*/
                                                                      /*CPB001*/
             IF         COND(%SST(&FMT 104 1) *EQ 'Y') THEN(DO)       /*CPB001*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'PB')) +
                             FMTOPT(*MAP *DROP)                       /*CPB001*/
                MONMSG     MSGID(CPF0000)                             /*CPB001*/
             ENDDO                                                    /*CPB001*/
                                                                      /*CPB001*/
/*  If LB is present - copy the LB records */                         /*S01498*/
                                                                      /*S01498*/
             IF         COND(%SST(&FMT 76 1) *EQ 'Y') THEN(DO)        /*S01498*/
/**********     CPYF       FROMFILE(SCJRNLB) TOFILE(QTEMP/RR1730) +   /*082565*/
/**********                  MBROPT(*ADD)                  /*S01498*/ /*082565*/
/**********     CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +  * *087083*/
/**********                  MBROPT(*ADD) INCREL((*IF MOD *EQ 'PM')) + *087083*/
/**********                  FMTOPT(*MAP *DROP)               *082565* *087083*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'LB')) +
                             FMTOPT(*MAP *DROP)                       /*087083*/
                MONMSG     MSGID(CPF0000)                             /*S01498*/
             ENDDO                                                    /*S01498*/
 
/*  If CF is present - copy the CF records */
 
             IF         COND(%SST(&FMT 70 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNCF) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'CF')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If HF is present - copy the HF records */                         /*S01379*/
                                                                      /*S01379*/
             IF         COND(%SST(&FMT 94 1) *EQ 'Y') THEN(DO)        /*S01379*/
/***********    CPYF       FROMFILE(SCJRNHF) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*S01379*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'HF')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)                             /*S01379*/
             ENDDO                                                    /*S01379*/
                                                                      /*S01522*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,RRC1730001                                           /*S01408*/
/* */                                                                 /*S01408*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,RRC1730003                                           /*S01408*/
/* */                                                                 /*S01408*/
/*  If CG is present - copy the CG records */                         /*S01522*/
                                                                      /*S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
/***********    CPYF       FROMFILE(SCJRNCG) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*S01522*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'CG')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)                             /*S01522*/
             ENDDO                                                    /*S01522*/
 
/***If*CM*is*present - copy the CM records */                         /*S01319*/
/************                                                         /*S01319*/
/************IF         COND(%SST(&FMT 35 1) *EQ 'Y') THEN(DO)        /*S01319*/
/************   CPYF       FROMFILE(SCJRNCM) TOFILE(QTEMP/RR1730) +   /*S01319*/
/************                MBROPT(*ADD)                             /*S01319*/
/************   MONMSG     MSGID(CPF0000)                             /*S01319*/
/************ENDDO                                                    /*S01319*/
 
/*  If FX or MM are present - copy the DL records */
 
             IF         COND((%SST(&FMT 23 1) *EQ 'Y') *OR +
                          (%SST(&FMT 48 1) *EQ 'Y')) THEN(DO)
/***********    CPYF       FROMFILE(SCJRNDL) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'DL')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/***If*FD*is*present - copy the FD records */                         /*S01319*/
/************                                                         /*S01319*/
/************IF         COND(%SST(&FMT 34 1) *EQ 'Y') THEN(DO)        /*S01319*/
/************   CPYF       FROMFILE(SCJRNFD) TOFILE(QTEMP/RR1730) +   /*S01319*/
/************                MBROPT(*ADD)                             /*S01319*/
/************   MONMSG     MSGID(CPF0000)                             /*S01319*/
/************ENDDO                                                    /*S01319*/
 
/*  If FF is present - copy the FF records */
 
/***********                                                          /*082565*/
             IF         COND(%SST(&FMT 41 1) *EQ 'Y') THEN(DO)
/***********   CPYF       FROMFILE(SCJRNFF) TOFILE(QTEMP/RR1730) +    /*082565*/
/***********                MBROPT(*ADD)                              /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'FF')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
               MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If FT is present - copy the FT records */
 
             IF         COND(%SST(&FMT 39 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNFT) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'FT')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/***If*FX*is*present - copy the FX records */                         /*S01319*/
/************                                                         /*S01319*/
/************IF         COND(%SST(&FMT 23 1) *EQ 'Y') THEN(DO)        /*S01319*/
/************   CPYF       FROMFILE(SCJRNFX) TOFILE(QTEMP/RR1730) +   /*S01319*/
/************                MBROPT(*ADD)                             /*S01319*/
/************   MONMSG     MSGID(CPF0000)                             /*S01319*/
/************ENDDO                                                    /*S01319*/
/************                                                         /*S01319*/
/***If*MM*is*present - copy the MM records */                         /*S01319*/
/************                                                         /*S01319*/
/************IF         COND(%SST(&FMT 48 1) *EQ 'Y') THEN(DO)        /*S01319*/
/************   CPYF       FROMFILE(SCJRNMM) TOFILE(QTEMP/RR1730) +   /*S01319*/
/************                MBROPT(*ADD)                             /*S01319*/
/************   MONMSG     MSGID(CPF0000)                             /*S01319*/
/************ENDDO                                                    /*S01319*/
 
/*  If IC is present - copy the IC records */
 
             IF         COND(%SST(&FMT 49 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNIC) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'IC')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If ME is present - copy the ME records */
 
             IF         COND(%SST(&FMT 46 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNME) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'ME')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If MS is present - copy the MS records */
 
             IF         COND(%SST(&FMT 30 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNMS) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'MS')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If MT is present - copy the MT records */
 
             IF         COND(%SST(&FMT 15 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNMT) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'MT')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If SE is present - copy the SE records */
 
             IF         COND(%SST(&FMT 31 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNSE) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'SE')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If TM is present - copy the TM records */
 
             IF         COND(%SST(&FMT 50 1) *EQ 'Y') THEN(DO)
/***********    CPYF       FROMFILE(SCJRNTM) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                             /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'TM')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  If ED is present - copy the ED records */                        /*S01493*/
                                                                     /*S01493*/
             IF         COND(%SST(&FMT 99 1) *EQ 'Y') THEN(DO)       /*S01493*/
/***********    CPYF       FROMFILE(SCJRNED) TOFILE(QTEMP/RR1730) +   /*082565*/
/***********                 MBROPT(*ADD)                  /*S01493*/ /*082565*/
                CPYF       FROMFILE(SCJRNPD) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'ED')) +
                             FMTOPT(*MAP *DROP)                       /*082565*/
                MONMSG     MSGID(CPF0000)                            /*S01493*/
             ENDDO                                                   /*S01493*/
                                                                     /*S01493*/
/*  Process the multiple module records  */
 
/* PM */                                                              /*S01486*/
             IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO)        /*S01486*/
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'PM') +
                             (*OR MOD1 *EQ 'PM') (*OR MOD2 *EQ 'PM') +
                             (*OR MOD3 *EQ 'PM') (*OR MOD4 *EQ 'PM') +
                             (*OR MOD5 *EQ 'PM') (*OR MOD6 *EQ 'PM') +
                             (*OR MOD7 *EQ 'PM') (*OR MOD8 *EQ 'PM') +
                             (*OR MOD9 *EQ 'PM'))                     /*S01486*/
                MONMSG     MSGID(CPF0000)                             /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*CPB001*/
/* PB */                                                              /*CPB001*/
             IF         COND(%SST(&FMT 104 1) *EQ 'Y') THEN(DO)       /*CPB001*/
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'PB') +
                             (*OR MOD1 *EQ 'PB') (*OR MOD2 *EQ 'PB') +
                             (*OR MOD3 *EQ 'PB') (*OR MOD4 *EQ 'PB') +
                             (*OR MOD5 *EQ 'PB') (*OR MOD6 *EQ 'PB') +
                             (*OR MOD7 *EQ 'PB') (*OR MOD8 *EQ 'PB') +
                             (*OR MOD9 *EQ 'PB'))                     /*CPB001*/
                MONMSG     MSGID(CPF0000)                             /*CPB001*/
             ENDDO                                                    /*CPB001*/
/* LB */                                                              /*S01498*/
             IF         COND(%SST(&FMT 76 1) *EQ 'Y') THEN(DO)        /*S01498*/
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'LB') +
                             (*OR MOD1 *EQ 'LB') (*OR MOD2 *EQ 'LB') +
                             (*OR MOD3 *EQ 'LB') (*OR MOD4 *EQ 'LB') +
                             (*OR MOD5 *EQ 'LB') (*OR MOD6 *EQ 'LB') +
                             (*OR MOD7 *EQ 'LB') (*OR MOD8 *EQ 'LB') +
                             (*OR MOD9 *EQ 'LB'))                     /*S01498*/
                MONMSG     MSGID(CPF0000)                             /*S01498*/
             ENDDO                                                    /*S01498*/
/* CF */
             IF         COND(%SST(&FMT 70 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'CF') +
                             (*OR MOD1 *EQ 'CF') (*OR MOD2 *EQ 'CF') +
                             (*OR MOD3 *EQ 'CF') (*OR MOD4 *EQ 'CF') +
                             (*OR MOD5 *EQ 'CF') (*OR MOD6 *EQ 'CF') +
                             (*OR MOD7 *EQ 'CF') (*OR MOD8 *EQ 'CF') +
                             (*OR MOD9 *EQ 'CF'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* HF */                                                              /*S01379*/
             IF         COND(%SST(&FMT 94 1) *EQ 'Y') THEN(DO)        /*S01379*/
                                                                      /*082565*/
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'HF') +
                             (*OR MOD1 *EQ 'HF') (*OR MOD2 *EQ 'HF') +
                             (*OR MOD3 *EQ 'HF') (*OR MOD4 *EQ 'HF') +
                             (*OR MOD5 *EQ 'HF') (*OR MOD6 *EQ 'HF') +
                             (*OR MOD7 *EQ 'HF') (*OR MOD8 *EQ 'HF') +
                             (*OR MOD9 *EQ 'HF'))                     /*S01379*/
                MONMSG     MSGID(CPF0000)                             /*S01379*/
             ENDDO                                                    /*S01379*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,RRC1730002                                           /*S01408*/
/* */                                                                 /*S01408*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,RRC1730004                                           /*S01408*/
/* */                                                                 /*S01408*/
                                                                      /*S01522*/
/* CG */                                                              /*S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'CG') +
                             (*OR MOD1 *EQ 'CG') (*OR MOD2 *EQ 'CG') +
                             (*OR MOD3 *EQ 'CG') (*OR MOD4 *EQ 'CG') +
                             (*OR MOD5 *EQ 'CG') (*OR MOD6 *EQ 'CG') +
                             (*OR MOD7 *EQ 'CG') (*OR MOD8 *EQ 'CG') +
                             (*OR MOD9 *EQ 'CG'))                     /*S01522*/
                MONMSG     MSGID(CPF0000)                             /*S01522*/
             ENDDO                                                    /*S01522*/
 
/**CM**/                                                              /*S01319*/
/************IF         COND(%SST(&FMT 35 1) *EQ 'Y') THEN(DO)        /*S01319*/
/************   CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +   /*S01319*/
/************                MBROPT(*ADD) INCREL((*IF MOD *EQ 'CM') + /*S01319*/
/************                (*OR MOD1 *EQ 'CM') (*OR MOD2 *EQ 'CM') +/*S01319*/
/************                (*OR MOD3 *EQ 'CM') (*OR MOD4 *EQ 'CM') +/*S01319*/
/************                (*OR MOD5 *EQ 'CM') (*OR MOD6 *EQ 'CM') +/*S01319*/
/************                (*OR MOD7 *EQ 'CM') (*OR MOD8 *EQ 'CM') +/*S01319*/
/************                (*OR MOD9 *EQ 'CM'))                     /*S01319*/
/************   MONMSG     MSGID(CPF0000)                             /*S01319*/
/************ENDDO                                                    /*S01319*/
 
/* DL */
             IF         COND((%SST(&FMT 23 1) *EQ 'Y') *OR +
                          (%SST(&FMT 48 1) *EQ 'Y')) THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'DL') +
                             (*OR MOD1 *EQ 'DL') (*OR MOD2 *EQ 'DL') +
                             (*OR MOD3 *EQ 'DL') (*OR MOD4 *EQ 'DL') +
                             (*OR MOD5 *EQ 'DL') (*OR MOD6 *EQ 'DL') +
                             (*OR MOD7 *EQ 'DL') (*OR MOD8 *EQ 'DL') +
                             (*OR MOD9 *EQ 'DL'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* EM */
             IF         COND(%SST(&FMT 25 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'EM') +
                             (*OR MOD1 *EQ 'EM') (*OR MOD2 *EQ 'EM') +
                             (*OR MOD3 *EQ 'EM') (*OR MOD4 *EQ 'EM') +
                             (*OR MOD5 *EQ 'EM') (*OR MOD6 *EQ 'EM') +
                             (*OR MOD7 *EQ 'EM') (*OR MOD8 *EQ 'EM') +
                             (*OR MOD9 *EQ 'EM'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/**FD**/                                                              /*S01319*/
/************IF         COND(%SST(&FMT 34 1) *EQ 'Y') THEN(DO)        /*S01319*/
/************   CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +   /*S01319*/
/************                MBROPT(*ADD) INCREL((*IF MOD *EQ 'FD') + /*S01319*/
/************                (*OR MOD1 *EQ 'FD') (*OR MOD2 *EQ 'FD') +/*S01319*/
/************                (*OR MOD3 *EQ 'FD') (*OR MOD4 *EQ 'FD') +/*S01319*/
/************                (*OR MOD5 *EQ 'FD') (*OR MOD6 *EQ 'FD') +/*S01319*/
/************                (*OR MOD7 *EQ 'FD') (*OR MOD8 *EQ 'FD') +/*S01319*/
/************                (*OR MOD9 *EQ 'FD'))                     /*S01319*/
/************   MONMSG     MSGID(CPF0000)                             /*S01319*/
/************ENDDO                                                    /*S01319*/
 
/* FF */
             IF         COND(%SST(&FMT 41 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'FF') +
                             (*OR MOD1 *EQ 'FF') (*OR MOD2 *EQ 'FF') +
                             (*OR MOD3 *EQ 'FF') (*OR MOD4 *EQ 'FF') +
                             (*OR MOD5 *EQ 'FF') (*OR MOD6 *EQ 'FF') +
                             (*OR MOD7 *EQ 'FF') (*OR MOD8 *EQ 'FF') +
                             (*OR MOD9 *EQ 'FF'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* FT */
             IF         COND(%SST(&FMT 39 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'FT') +
                             (*OR MOD1 *EQ 'FT') (*OR MOD2 *EQ 'FT') +
                             (*OR MOD3 *EQ 'FT') (*OR MOD4 *EQ 'FT') +
                             (*OR MOD5 *EQ 'FT') (*OR MOD6 *EQ 'FT') +
                             (*OR MOD7 *EQ 'FT') (*OR MOD8 *EQ 'FT') +
                             (*OR MOD9 *EQ 'FT'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/**FX**/                                                              /*S01319*/
/************IF         COND(%SST(&FMT 23 1) *EQ 'Y') THEN(DO)        /*S01319*/
/************   CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +   /*S01319*/
/************                MBROPT(*ADD) INCREL((*IF MOD *EQ 'FX') + /*S01319*/
/************                (*OR MOD1 *EQ 'FX') (*OR MOD2 *EQ 'FX') +/*S01319*/
/************                (*OR MOD3 *EQ 'FX') (*OR MOD4 *EQ 'FX') +/*S01319*/
/************                (*OR MOD5 *EQ 'FX') (*OR MOD6 *EQ 'FX') +/*S01319*/
/************                (*OR MOD7 *EQ 'FX') (*OR MOD8 *EQ 'FX') +/*S01319*/
/************                (*OR MOD9 *EQ 'FX'))                     /*S01319*/
/************   MONMSG     MSGID(CPF0000)                             /*S01319*/
/************ENDDO                                                    /*S01319*/
 
/* GL */
             CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                          MBROPT(*ADD) INCREL((*IF MOD *EQ 'GL') +
                          (*OR MOD1 *EQ 'GL') (*OR MOD2 *EQ 'GL') +
                          (*OR MOD3 *EQ 'GL') (*OR MOD4 *EQ 'GL') +
                          (*OR MOD5 *EQ 'GL') (*OR MOD6 *EQ 'GL') +
                          (*OR MOD7 *EQ 'GL') (*OR MOD8 *EQ 'GL') +
                          (*OR MOD9 *EQ 'GL'))
             MONMSG     MSGID(CPF0000)
 
/* IC */
             IF         COND(%SST(&FMT 49 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'IC') +
                             (*OR MOD1 *EQ 'IC') (*OR MOD2 *EQ 'IC') +
                             (*OR MOD3 *EQ 'IC') (*OR MOD4 *EQ 'IC') +
                             (*OR MOD5 *EQ 'IC') (*OR MOD6 *EQ 'IC') +
                             (*OR MOD7 *EQ 'IC') (*OR MOD8 *EQ 'IC') +
                             (*OR MOD9 *EQ 'IC'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* LE */
             IF         COND(%SST(&FMT 28 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'LE') +
                             (*OR MOD1 *EQ 'LE') (*OR MOD2 *EQ 'LE') +
                             (*OR MOD3 *EQ 'LE') (*OR MOD4 *EQ 'LE') +
                             (*OR MOD5 *EQ 'LE') (*OR MOD6 *EQ 'LE') +
                             (*OR MOD7 *EQ 'LE') (*OR MOD8 *EQ 'LE') +
                             (*OR MOD9 *EQ 'LE'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* ME */
             IF         COND(%SST(&FMT 46 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'ME') +
                             (*OR MOD1 *EQ 'ME') (*OR MOD2 *EQ 'ME') +
                             (*OR MOD3 *EQ 'ME') (*OR MOD4 *EQ 'ME') +
                             (*OR MOD5 *EQ 'ME') (*OR MOD6 *EQ 'ME') +
                             (*OR MOD7 *EQ 'ME') (*OR MOD8 *EQ 'ME') +
                             (*OR MOD9 *EQ 'ME'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/**MM**/                                                              /*S01319*/
/************IF         COND(%SST(&FMT 48 1) *EQ 'Y') THEN(DO)        /*S01319*/
/************   CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +   /*S01319*/
/************                MBROPT(*ADD) INCREL((*IF MOD *EQ 'MM') + /*S01319*/
/************                (*OR MOD1 *EQ 'MM') (*OR MOD2 *EQ 'MM') +/*S01319*/
/************                (*OR MOD3 *EQ 'MM') (*OR MOD4 *EQ 'MM') +/*S01319*/
/************                (*OR MOD5 *EQ 'MM') (*OR MOD6 *EQ 'MM') +/*S01319*/
/************                (*OR MOD7 *EQ 'MM') (*OR MOD8 *EQ 'MM') +/*S01319*/
/************                (*OR MOD9 *EQ 'MM'))                     /*S01319*/
/************   MONMSG     MSGID(CPF0000)                             /*S01319*/
/************ENDDO                                                    /*S01319*/
 
/* MS */
             IF         COND(%SST(&FMT 30 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'MS') +
                             (*OR MOD1 *EQ 'MS') (*OR MOD2 *EQ 'MS') +
                             (*OR MOD3 *EQ 'MS') (*OR MOD4 *EQ 'MS') +
                             (*OR MOD5 *EQ 'MS') (*OR MOD6 *EQ 'MS') +
                             (*OR MOD7 *EQ 'MS') (*OR MOD8 *EQ 'MS') +
                             (*OR MOD9 *EQ 'MS'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* MT */
             IF         COND(%SST(&FMT 15 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'MT') +
                             (*OR MOD1 *EQ 'MT') (*OR MOD2 *EQ 'MT') +
                             (*OR MOD3 *EQ 'MT') (*OR MOD4 *EQ 'MT') +
                             (*OR MOD5 *EQ 'MT') (*OR MOD6 *EQ 'MT') +
                             (*OR MOD7 *EQ 'MT') (*OR MOD8 *EQ 'MT') +
                             (*OR MOD9 *EQ 'MT'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* RE */
             IF         COND(%SST(&FMT 29 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'RE') +
                             (*OR MOD1 *EQ 'RE') (*OR MOD2 *EQ 'RE') +
                             (*OR MOD3 *EQ 'RE') (*OR MOD4 *EQ 'RE') +
                             (*OR MOD5 *EQ 'RE') (*OR MOD6 *EQ 'RE') +
                             (*OR MOD7 *EQ 'RE') (*OR MOD8 *EQ 'RE') +
                             (*OR MOD9 *EQ 'RE'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* SD */
             CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                          MBROPT(*ADD) INCREL((*IF MOD *EQ 'SD') +
                          (*OR MOD1 *EQ 'SD') (*OR MOD2 *EQ 'SD') +
                          (*OR MOD3 *EQ 'SD') (*OR MOD4 *EQ 'SD') +
                          (*OR MOD5 *EQ 'SD') (*OR MOD6 *EQ 'SD') +
                          (*OR MOD7 *EQ 'SD') (*OR MOD8 *EQ 'SD') +
                          (*OR MOD9 *EQ 'SD'))
             MONMSG     MSGID(CPF0000)
 
/* S1 */                                                              /*E34675*/
             CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                          MBROPT(*ADD) INCREL((*IF MOD *EQ 'S1') +
                          (*OR MOD1 *EQ 'S1') (*OR MOD2 *EQ 'S1') +
                          (*OR MOD3 *EQ 'S1') (*OR MOD4 *EQ 'S1') +
                          (*OR MOD5 *EQ 'S1') (*OR MOD6 *EQ 'S1') +
                          (*OR MOD7 *EQ 'S1') (*OR MOD8 *EQ 'S1') +
                          (*OR MOD9 *EQ 'S1'))                        /*E34675*/
             MONMSG     MSGID(CPF0000)                                /*E34675*/
                                                                      /*E34675*/
/* SE */
             IF         COND(%SST(&FMT 31 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'SE') +
                             (*OR MOD1 *EQ 'SE') (*OR MOD2 *EQ 'SE') +
                             (*OR MOD3 *EQ 'SE') (*OR MOD4 *EQ 'SE') +
                             (*OR MOD5 *EQ 'SE') (*OR MOD6 *EQ 'SE') +
                             (*OR MOD7 *EQ 'SE') (*OR MOD8 *EQ 'SE') +
                             (*OR MOD9 *EQ 'SE'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/* TM */
             IF         COND(%SST(&FMT 50 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'TM') +
                             (*OR MOD1 *EQ 'TM') (*OR MOD2 *EQ 'TM') +
                             (*OR MOD3 *EQ 'TM') (*OR MOD4 *EQ 'TM') +
                             (*OR MOD5 *EQ 'TM') (*OR MOD6 *EQ 'TM') +
                             (*OR MOD7 *EQ 'TM') (*OR MOD8 *EQ 'TM') +
                             (*OR MOD9 *EQ 'TM'))
                MONMSG     MSGID(CPF0000)
             ENDDO
                                                                      /*S01493*/
/* ED */                                                              /*S01493*/
             IF         COND(%SST(&FMT 99 1) *EQ 'Y') THEN(DO)        /*S01493*/
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'ED') +
                             (*OR MOD1 *EQ 'ED') (*OR MOD2 *EQ 'ED') +
                             (*OR MOD3 *EQ 'ED') (*OR MOD4 *EQ 'ED') +
                             (*OR MOD5 *EQ 'ED') (*OR MOD6 *EQ 'ED') +
                             (*OR MOD7 *EQ 'ED') (*OR MOD8 *EQ 'ED') +
                             (*OR MOD9 *EQ 'ED'))                     /*S01493*/
                MONMSG     MSGID(CPF0000)                             /*S01493*/
             ENDDO
 
/*  PL*/                     /*    CPL002 Amendment  START */
 
             IF         COND(%SST(&FMT 102 1) *EQ 'Y') THEN(DO)
                CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                             MBROPT(*ADD) INCREL((*IF MOD *EQ 'PL') +
                             (*OR MOD1 *EQ 'PL') (*OR MOD2 *EQ 'PL') +
                             (*OR MOD3 *EQ 'PL') (*OR MOD4 *EQ 'PL') +
                             (*OR MOD5 *EQ 'PL') (*OR MOD6 *EQ 'PL') +
                             (*OR MOD7 *EQ 'PL') (*OR MOD8 *EQ 'PL') +
                             (*OR MOD9 *EQ 'PL'))
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  CPL002 Amendment  END */
 
/* SS */                                                              /*S01407*/
/* Switchable SARS */                                                 /*S01407*/
/* */                                                                 /*S01407*/
             CPYF       FROMFILE(SCJRN##) TOFILE(QTEMP/RR1730) +
                          MBROPT(*ADD) INCREL((*IF MOD *EQ 'SS') +
                          (*OR MOD1 *EQ 'SS') (*OR MOD2 *EQ 'SS') +
                          (*OR MOD3 *EQ 'SS') (*OR MOD4 *EQ 'SS') +
                          (*OR MOD5 *EQ 'SS') (*OR MOD6 *EQ 'SS') +
                          (*OR MOD7 *EQ 'SS') (*OR MOD8 *EQ 'SS') +
                          (*OR MOD9 *EQ 'SS'))                        /*S01407*/
             MONMSG     MSGID(CPF0000)                                /*S01407*/
 
/*  Copy from work file to processing file  */
 
/**********  CPYF       FROMFILE(QTEMP/RR1730) TOFILE(RRJRNPD) +      /*082565*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP)         /*082565*/
             CPYF       FROMFILE(QTEMP/RR1730) TOFILE(RRJRNPD) +
                          MBROPT(*REPLACE) INCREL((*IF RECI *EQ ' +
                          ')) FMTOPT(*MAP *DROP)                      /*082565*/
 
/*  Call RR1730 to copy PF/RRJRNPD to PF/JRNFIL  */
 
             CALL       PGM(RR1730)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
