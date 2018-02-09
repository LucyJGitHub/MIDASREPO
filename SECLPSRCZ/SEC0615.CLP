/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Clear Account Key Files')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC0615 - Clear Account Key Files                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE036             Date 22Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU017             Date 03Mar98              */
/*                      CSE007             Date 03Feb98              */
/*                      S01496             DATE 24OCT94              */
/*                      S01117             DATE 09JAN91              */
/*                      S01179             DATE 16/09/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE036 - Unrealised Profit and Loss Report by Trade         */
/*       CEU017 - Securities Redenomination Euro Changes             */
/*       CSE007 - Corporate Actions                                  */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01179 -  RELEASE                                        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01496*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01496*/
             DCL        VAR(&S01496) TYPE(*CHAR) LEN(1)               /*S01496*/
             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1)               /*CSE007*/
             DCL        VAR(&CEU017) TYPE(*CHAR) LEN(1)               /*CEU017*/
/*/COPY WNCPYSRC,SEC0615001                                          */
/**/                                                                  /*S01496*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01496*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01496*/
             CHGVAR     VAR(&SAR) VALUE('S01496')                     /*S01496*/
             CHGVAR     VAR(&S01496) VALUE('N')                       /*S01496*/
/**/                                                                  /*S01496*/
/**  Check if Jyske Enhancements is installed */                      /*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01496*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01496*/
                CHGVAR     VAR(&S01496) VALUE('Y')                    /*S01496*/
             ENDDO                                                    /*S01496*/
/**/                                                                  /*CSE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE007*/
             CHGVAR     VAR(&SAR) VALUE('CSE007')                     /*CSE007*/
             CHGVAR     VAR(&CSE007) VALUE('N')                       /*CSE007*/
/**/                                                                  /*CSE007*/
/**  Check if Corporate Action is installed */                        /*CSE007*/
/**/                                                                  /*CSE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE007*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE007*/
                CHGVAR     VAR(&CSE007) VALUE('Y')                    /*CSE007*/
             ENDDO                                                    /*CSE007*/
/**/                                                                  /*CEU017*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
             CHGVAR     VAR(&SAR) VALUE('CEU017')                     /*CEU017*/
             CHGVAR     VAR(&CEU017) VALUE('N')                       /*CEU017*/
/**/                                                                  /*CEU017*/
/**  Check if Securities Redenomination is installed **/              /*CEU017*/
/**/                                                                  /*CEU017*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU017*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CEU017*/
                CHGVAR     VAR(&CEU017) VALUE('Y')                    /*CEU017*/
             ENDDO                                                    /*CEU017*/
/*/COPY WNCPYSRC,SEC0615002                                          */
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0615  - Clear +
                          Account Key files')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
 
/*   CLEAR SEKEYA FILES */
 
             CLRPFM     FILE(SEKEYA) MBR(ACCRUAL)
             CLRPFM     FILE(SEKEYA) MBR(BKMATUR)
             CLRPFM     FILE(SEKEYA) MBR(BKPOSN)
             CLRPFM     FILE(SEKEYA) MBR(BKPOSNR)
             CLRPFM     FILE(SEKEYA) MBR(CONTLIAB)
             CLRPFM     FILE(SEKEYA) MBR(CPOSN1)
             CLRPFM     FILE(SEKEYA) MBR(CPOSN2)
             CLRPFM     FILE(SEKEYA) MBR(DEPOTMVT)
             CLRPFM     FILE(SEKEYA) MBR(DPOSN1)
             CLRPFM     FILE(SEKEYA) MBR(DPOSN2)
             CLRPFM     FILE(SEKEYA) MBR(MMREVAL)
             CLRPFM     FILE(SEKEYA) MBR(PSETTLE)
             CLRPFM     FILE(SEKEYA) MBR(TRADE)
             CLRPFM     FILE(SEKEYA) MBR(TSETTLE)
             CLRPFM     FILE(SEKEYA) MBR(UNPL)                                            /*CSE036*/
/*/COPY WNCPYSRC,SEC0615005                                          */
             IF         COND(&S01496 *EQ 'Y') THEN(DO)                /*S01496*/
                CLRPFM     FILE(SEKEYA) MBR(REDEMP)                   /*S01496*/
             ENDDO                                                    /*S01496*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                CLRPFM     FILE(SEKEYA) MBR(CORPAC)                   /*CSE007*/
             ENDDO                                                    /*CSE007*/
/*/COPY WNCPYSRC,SEC0615003                                          */
 
 
/*   CLEAR SEKEYD FILES */
 
             CLRPFM     FILE(SEKEYD) MBR(ACCRUAL)
             CLRPFM     FILE(SEKEYD) MBR(BKMATUR)
             CLRPFM     FILE(SEKEYD) MBR(BKPOSN)
             CLRPFM     FILE(SEKEYD) MBR(BKPOSNR)
             CLRPFM     FILE(SEKEYD) MBR(CONTLIAB)
             CLRPFM     FILE(SEKEYD) MBR(CPOSN1)
             CLRPFM     FILE(SEKEYD) MBR(CPOSN2)
             CLRPFM     FILE(SEKEYD) MBR(DEPOTMVT)
             CLRPFM     FILE(SEKEYD) MBR(DPOSN1)
             CLRPFM     FILE(SEKEYD) MBR(DPOSN2)
             CLRPFM     FILE(SEKEYD) MBR(MMREVAL)
             CLRPFM     FILE(SEKEYD) MBR(PSETTLE)
             CLRPFM     FILE(SEKEYD) MBR(TRADE)
             CLRPFM     FILE(SEKEYD) MBR(TSETTLE)
             CLRPFM     FILE(SEKEYD) MBR(UNPL)                                            /*CSE036*/
/*/COPY WNCPYSRC,SEC0615006                                          */
             IF         COND(&S01496 *EQ 'Y') THEN(DO)                /*S01496*/
                CLRPFM     FILE(SEKEYD) MBR(REDEMP)                   /*S01496*/
             ENDDO                                                    /*S01496*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                CLRPFM     FILE(SEKEYD) MBR(CORPAC)                   /*CSE007*/
             ENDDO                                                    /*CSE007*/
/*/COPY WNCPYSRC,SEC0615004                                          */
 
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
