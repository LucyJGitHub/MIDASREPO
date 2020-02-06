/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA/IRS Rate Changes Expected Extrct')       */
/********************************************************************/
/*                                                                  */
/* Midas - Dealing Module                                   */
/*                                                                  */
/* DLC1610 - DEALS WITH RATE CHANGES EXPECTED REPORT                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL033             Date 10Feb05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 21Aug90              */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   CDL033 - Floating rate CDs issued                               */
/*   S01117 - RELEASE 10 - MULTIBRANCHING - RCF                      */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7) VALUE('       ')                  /*CDL033*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                  /*CDL033*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6) VALUE('CDL033')                   /*CDL033*/
             DCL        VAR(&CDL033) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CDL033*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CDL033*/
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CDL033*/
             IF         COND(&RTCD *EQ '       ') +
                          THEN(CHGVAR VAR(&CDL033) VALUE('Y'))                            /*CDL033*/
/*/COPY WNCPYSRC,DLC1610002                                          */
                CLRPFM     FILE(DLDGXD)
                CLRPFM     FILE(DLDGXZ)
                CALL       PGM(DL1610)
/**/
             RTVJOBA    SWS(&SWS)
/*/COPY WNCPYSRC,DLC1610001                                          */
             IF         COND(&CDL033 = 'Y') THEN(DO)                                      /*CDL033*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(CALL +
                          PGM(DL1611))                                                    /*CDL033*/
             RTVJOBA    SWS(&SWS)                                                         /*CDL033*/
             ENDDO                                                                        /*CDL033*/
/**/
/************IF*********COND(%SUBSTRING(&SWS 6 3) *EQ '000') THEN(+*****S01117*/
/***********************CALL PGM(DL1620))*******************************S01117*/
             IF         COND(%SUBSTRING(&SWS 6 3) *EQ '000') +
                          THEN(CALL PGM(DL1620) PARM(&RSEQ))          /*S01117*/
/**/
             CHGVAR     VAR(&SWS) VALUE('XXXXX0XX')
             CHGJOB     SWS(&SWS)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
