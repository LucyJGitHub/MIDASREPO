/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Cost of Funds Report')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                   */
/*                                                                   */
/*       SEC0805 - COST OF FUNDS REPORT                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. DUG504             Date 06Sep17              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S11029             Date 19Apr93              */
/*                      S01117             Date 09Jan91              */
/*                      S01179             DATE 16/09/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DUG504 - Cost of Funds                                      */
/*                Added hooks DUG504_001, DUG504_002, DUG504_003 and */
/*                DUG504_004                                         */
/*       MD046248 - Finastra Rebranding                              */
/*       S11029 - RPG Programs rewritten to extract Year-to-date     */
/*                Funding information. Therefore names changed.      */
/*                Also now changed so that instead of using the CL   */
/*                to select a Branch from the Extract, just need to  */
/*                extract the one Branch in the first place.         */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01179 -  RELEASE                                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/*/COPY WNCPYSRC,DUG504_001                                          */                   /*DUG504*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0805 - Cost of Funds +
                          Report')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,DUG504_002                                          */                   /*DUG504*/
 
/* CLEAR FILES */
 
             CLRPFM     FILE(COFEXD)
             CLRPFM     FILE(COFEXA)
 
/* CALL COST OF FUNDS EXTRACT PROGRAM */
 
/***********    CALL       PGM(SE1080)  ***/                          /*S11029*/
/*/COPY WNCPYSRC,DUG504_003                                          */                   /*DUG504*/
             CALL (SE1081) PARM(&RENT)                                /*S11029*/
 
/* IF NO ERRORS CALL COST OF FUNDS REPORT PROGRAM */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/********POSITION*FILE*TO*THE*PARTICULAR*BRANCH***********   *S01117* /*S11029*/
/**********IF COND((&RENT *NE '   ') *AND (&RENT *NE + ***   *S01117* /*S11029*/
/**********                           'ALL') THEN(DO)  ***   *S01117* /*S11029*/
/*********** OVRDBF     FILE(COFEXD) POSITION(*KEY 1 + ***   *S01117* /*S11029*/
/***********                           COFEXDF &RENT)  ***   *S01117* /*S11029*/
/*********** OVRDBF     FILE(COFEXD) POSITION(*KEY 1 + ***   *S01117* /*S11029*/
/***********                           COFEXDF &RENT)  ***   *S01117* /*S11029*/
/*********** OPNDBF     FILE(COFEXD) OPTION(*ALL)      ***   *S01117* /*S11029*/
/*********** MONMSG     MSGID(CPF0000) EXEC(DO)        ***   *S01117* /*S11029*/
/***********   DLTOVR     FILE(COFEXD)                 ***   *S01117* /*S11029*/
/*********** ENDDO                                     ***   *S01117* /*S11029*/
/*********** CLOF       OPNID(COFEXD)                  ***   *S01117* /*S11029*/
/*********** MONMSG     MSGID(CPF0000)                                /*S01117*/
/**********ENDDO                                                      /*S01117*/
 
/***************CALL       PGM(SE1085)                               * *S01117*/
/***********    CALL       PGM(SE1085) PARM(&RSEQ &RENT)  ***  /*S01117 S01401*/
                                                                      /*S01401*/
             CALL (SE1086) PARM(&RSEQ)                                /*S01401*/
             ENDDO
/*/COPY WNCPYSRC,DUG504_004                                          */                   /*DUG504*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0805 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
              CHGVAR     VAR(&MEM) VALUE('SEC0805 - File Controls Out +
                          of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                ENDPGM
