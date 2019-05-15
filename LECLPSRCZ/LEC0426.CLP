/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Requested rollover confirmation (COB)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0426 - Requested Rollover Confirmations (COB)            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 15May96              */
/*                      084617             Date 13Apr95              */
/*                      S01465             DATE  22MAR94             */
/*                      BH3413             DATE  15JUL92             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Core hook LEC0426002 added                         */
/*                Core hook LEC0426001 added                         */
/*       084617 - Add global monitor message processing              */
/*       S01465 - BLI Lending Enhancements                           */
/*       BH3413 - Clear of requested rollover confs file             */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                     /*S01465*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                 /*S01465*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)            /*S01465*/
/*/COPY WNCPYSRC,LEC0426004                                          */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))                              /*084617*/
                                                                      /*084617*/
/*/COPY WNCPYSRC,LEC0426005                                          */
/**          CHGJOB     SWS(XX1XXXXX)                          0085**/
 
/**/                                                                 /*S01465*/
/**  Access SAR file to determine if the switchable feature for   */ /*S01465*/
/**  S01465 is switched on                                           /*S01465*/
/**/                                                                 /*S01465*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                  /*S01465*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                  /*S01465*/
             CHGVAR     VAR(&SAR) VALUE('S01465')                    /*S01465*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) /*S01465*/
/**/                                                                 /*S01465*/
/**  If switchable feature is on, call LE1170.  Else, call LE0426 */ /*S01465*/
/**/                                                                 /*S01465*/
/*/COPY WNCPYSRC,LEC0426003                                          */
             IF         COND(&RTCD *EQ '       ') THEN(+
                CALL       PGM(LE1170))                              /*S01465*/
             ELSE       CMD(DO)                                      /*S01465*/
/**                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0426002                                          /*S01408*/
/**                                                                  /*S01408*/
             CALL       PGM(LE0426)
/**                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0426001                                          /*S01408*/
/**                                                                  /*S01408*/
             ENDDO                                                   /*S01465*/
/*/COPY WNCPYSRC,LEC0426006                                          */
 
/**          CHGJOB     SWS(XX0XXXXX)                          0085**/
/**          IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +    0085**/
/**                       CMDLBL(ERROR))                       0085**/
 
/**          IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(END))                         BH3413*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)     /*BH3413*/
             CLRPFM     FILE(ROLRECS)                        /*BH3413*/
             GOTO         CMDLBL(END)                        /*BH3413*/
             ENDDO                                           /*BH3413*/
 
/* IF THERE ARE ERRORS OUTPUT THE DETAILS TO THE MESSAGE QUEUE */
 
   ERROR:
           IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                /*084617*/
             RTVDTAARA DTAARA(LDA) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*084617*/
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*084617*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*084617*/
           ENDDO                                                      /*084617*/
           IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                /*084617*/
             SNDPGMMSG  MSG('LEC0426 - COB Requested Rollover +
                          Confirmations TERMINATED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*084617*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*084617*/
             DMPCLPGM                                                 /*084617*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*084617*/
           ENDDO                                                      /*084617*/
   END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
   ENDPGM
