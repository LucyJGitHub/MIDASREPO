/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Limits to be Reviewed Report')               */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0909   LIMITS TO BE REVIEWED REPORT                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117                  DATE  10JAN91       */
/*       PREV AMEND NO. S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01179 -     RELEASE                                     */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/* S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                  ********/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0909  - Limits To B+
                        e Reviewed Report')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
/*       OVERRIDE TO THE FIRST FILE SLIMEL                           * *S01117*/
             OVRDBF     FILE(SLIMEL) POSITION(*KEY 1 SLIMEF &RENT)    /*S01117*/
             OPNDBF     FILE(SLIMEL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
/*       IF THIS IS EMPTY OVERRIDE TO THE SECOND FILE SLIMGL         * *S01117*/
               DLTOVR     FILE(SLIMEL)                                /*S01117*/
               OVRDBF     FILE(SLIMGL) POSITION(*KEY 1 SLIMGF &RENT)  /*S01117*/
               OPNDBF     FILE(SLIMGL) OPTION(*ALL)                   /*S01117*/
               MONMSG     MSGID(CPF0000) EXEC(DO)                     /*S01117*/
/*       IF THIS IS EMPTY OVERRIDE TO THE THIRD FILE SLIMFL          * *S01117*/
                 DLTOVR     FILE(SLIMGL)                              /*S01117*/
                 OVRDBF    FILE(SLIMFF) POSITION(*KEY 1 SLIMFF &RENT) /*S01117*/
                 OPNDBF     FILE(SLIMFF) OPTION(*ALL)                 /*S01117*/
                 MONMSG     MSGID(CPF0000) EXEC(DO)                   /*S01117*/
/*       IF THIS IS EMPTY OVERRIDE TO THE FOURTH FILE SLIMHL         * *S01117*/
                   DLTOVR     FILE(SLIMFL)                            /*S01117*/
                  OVRDBF   FILE(SLIMHF) POSITION(*KEY 1 SLIMHF &RENT) /*S01117*/
                   OPNDBF     FILE(SLIMHF) OPTION(*ALL)               /*S01117*/
                   MONMSG     MSGID(CPF0000) EXEC(DO)                 /*S01117*/
/*       IF THIS IS EMPTY OVERRIDE TO THE FIFTH FILE SLIMIL          * *S01117*/
                     DLTOVR     FILE(SLIMHL)                          /*S01117*/
                  OVRDBF   FILE(SLIMIF) POSITION(*KEY 1 SLIMIF &RENT) /*S01117*/
                     OPNDBF     FILE(SLIMIF) OPTION(*ALL)             /*S01117*/
                     MONMSG     MSGID(CPF0000) EXEC(DO)               /*S01117*/
                       DLTOVR     FILE(SLIMIL)                        /*S01117*/
                     ENDDO                                            /*S01117*/
                     CLOF       OPNID(SLIMIL)                         /*S01117*/
                    MONMSG     MSGID(CPF0000)                         /*S01117*/
                   ENDDO                                              /*S01117*/
                   CLOF       OPNID(SLIMHL)                           /*S01117*/
                  MONMSG     MSGID(CPF0000)                           /*S01117*/
                 ENDDO                                                /*S01117*/
                 CLOF       OPNID(SLIMFL)                             /*S01117*/
                MONMSG     MSGID(CPF0000)                             /*S01117*/
               ENDDO                                                  /*S01117*/
               CLOF       OPNID(SLIMGL)                               /*S01117*/
              MONMSG     MSGID(CPF0000)                               /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMEL)                                 /*S01117*/
            MONMSG     MSGID(CPF0000)                                 /*S01117*/
           ENDDO                                                      /*S01117*/
 
/* CALL PROGRAM                                                  */
 
/************CALL       PGM(SE0980)                                  * *S01117*/
             CALL       PGM(SE0980) PARM(&RSEQ &RENT)                 /*S01117*/
 
             DLTOVR     FILE(*ALL)                                    /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0909  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0909  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
