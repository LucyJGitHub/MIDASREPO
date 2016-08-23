/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Daily Schedule of Transactions')             */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0612B  DAILY SCHEDULE OF TRANSACTIONS                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117                  DATE  10DEC90       */
/*                                                                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01117 - MULTI-BRANCHING                                   */
/********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/*           DCLDTAARA  DTAARA(LDA)                                */ /*S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
 
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0612B - Daily Schedule +
                            of Transactions')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CLEAR OUTPUT FILES                                            */
 
             CLRPFM DSTEXA
             CLRPFM DSTEXD
/*/COPY WNCPYSRC,SEC0612B01                                          */
 
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
 
/* CALL PROGRAM                                                  */
 
             CALL       PGM(SE0610)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*              RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       */ /*S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0612B - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO       ENDPGM
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0612B - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO       ENDPGM
             ENDDO
 
/* CALL REPORT PGM.                                              */
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
/*/COPY WNCPYSRC,SEC0612B02                                          */
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
             OVRDBF     FILE(DSTEX) POSITION(*KEY 1 DSTEXDF &RENT)    /*S01117*/
             OPNDBF     FILE(DSTEX) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
               DLTOVR     FILE(DSTEX)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(DSTEX)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
           ENDDO                                                      /*S01117*/
/*/COPY WNCPYSRC,SEC0612B03                                          */
 
/************CALL       PGM(SE0615)                                  * *S01117*/
             CALL       PGM(SE0615) PARM(&RSEQ &RENT)                 /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*              RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       */ /*S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0612B - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0612B - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
