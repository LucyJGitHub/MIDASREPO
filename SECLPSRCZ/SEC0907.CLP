/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Monthly Depot Movements')                    */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0907   MONTHLY DEPOT MOVEMENTS REPORT                   */
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
/*       Prev Amend No. S01117             Date 10Jan91              */
/*                      S01179             Date 16/09/88             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01179 -     RELEASE                                     */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&PARM)                                  * *S01117*/
             PGM        PARM(&PARM &RSEQ &RLEV &RENT)                 /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0907  - Monthly Depot +
                          Movements Report')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*     RESET SWITCHES                                               */
 
             CHGJOB     SWS(00000000)
 
/*   CLEAR O/P FILES */
 
             CLRPFM     FILE(MDMEXD)
             CLRPFM     FILE(MDMEXA)
 
 
/*   CALL EXTRACT PROGRAM                        */
 
             CALL       PGM(SE0960)
 
/**/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(LDA)                         *********  *S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))           * *S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('SEC0907 - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO ENDPGM
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             SNDPGMMSG  MSG('SEC0907 - File Controls out of Balance') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO ENDPGM
             ENDDO
/**/
 
/*   CALL REPORT PROGRAM                        */
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
             OVRDBF     FILE(MDMEX) POSITION(*KEY 1 MDMEXDF &RENT)    /*S01117*/
             OPNDBF     FILE(MDMEX) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
               DLTOVR     FILE(MDMEX)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(MDMEX)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
           ENDDO                                                      /*S01117*/
 
/************CALL       PGM(SE0965) PARM(&PARM)                      * *S01117*/
             CALL       PGM(SE0965) PARM(&PARM &RSEQ &RENT)           /*S01117*/
 
/**/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(LDA)                         *********  *S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))           * *S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('SEC0907 - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO ENDPGM
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                          MSG('SEC0907 - File Controls out of +
                          Balance') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ))
/**/
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
