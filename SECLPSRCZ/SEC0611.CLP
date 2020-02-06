/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Advance confirmations')                      */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                        */
/*                                                                  */
/*       SEC0611 - ADVANCE CONFIRMATIONS                            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 086128             Date 01Mar95              */
/*                      JOURN              Date 24Feb95              */
/*                      S01522             DATE 12JAN95             */
/*                      S01117             DATE 08JAN91             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       086128 - Move CG extract to CGC2210                         */
/*       JOURN  - FILE CPEVED HAS TO BE JOURNALLED                  */
/*       S01522 - USER DEFINED CORRESPONDENCE                       */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*           DCLDTAARA  DTAARA(LDA)                                */ /*S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*S01522*/
             DCL        VAR(&UDC)   TYPE(*CHAR) LEN(1)                /*S01522*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
/*/COPY WNCPYSRC,SEC0611001                                          */
 
/* SEND START MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0611 - Advance +
                          Confirmations')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/***********                                                           *086128*/
/*** *******                                                   *S01522**086128*/
/**User*Defined Correspondence processing  *                   *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/***Access*PF/SDMMODPD to determine whether UDC module is on   *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** CALL       PGM(AOMMODR0) PARM(&PRTCD '*FIRST ' &FMT)01522**086128*/
/*** *******                                                   *S01522**086128*/
/***Database error handling                                    *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** IF         COND(&PRTCD *NE '       ') THEN(DO)    *S01522**086128*/
/*********** CHGJOB     SWS(XXXXXX11)                          *S01522**086128*/
/*********** GOTO       CMDLBL(ERROR)                          *S01522**086128*/
/*********** ENDDO                                             *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)*S01522**086128*/
/*********** CHGVAR (&UDC) VALUE('Y')                          *S01522**086128*/
/*********** ENDDO                                             *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** OVRDBF     FILE(CPEVE) SHARE(*NO)                 *S01522**086128*/
/*********** IF         COND(&UDC *EQ 'Y') THEN(DO)            *S01522**086128*/
/*********** STRJRNPF   FILE(CPEVED) JRN(CGCOBJRN)             *JOURN* *086128*/
/*********** STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))     *S01522**086128*/
/*********** CALL       PGM(CG4400) PARM(&W0RTN &W0CMT)        *S01522**086128*/
/*********** IF         COND(&W0RTN *NE '       ') THEN(DO)    *S01522**086128*/
/*********** CHGJOB     SWS(XXXXXX11)                          *S01522**086128*/
/*********** GOTO       CMDLBL(ERROR)                          *S01522**086128*/
/*********** ENDDO                                             *S01522**086128*/
/*********** ENDDO                                             *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/* CALL ADVANCE CONFIRMATIONS PROGRAM */
/*/COPY WNCPYSRC,SEC0611002                                          */
 
             CALL       PGM(SE0570)
 
ERROR:                                                                /*S01522*/
/* IF EXTERNAL SWITCHES U7 AND U8 ON, RECOVER DATA FROM LDA */
/* AND SEND ERROR MESSAGES */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RCVDTAARA  DTAARA(LDA)                                */ /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))     * *S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))      /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0611 - Database Error')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* IF EXTERNAL SWITCH U8 ON, SEND 'FILES OUT OF BALANCE' MESSAGE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE('SEC0611 - File Controls Out +
                          of Balance')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
