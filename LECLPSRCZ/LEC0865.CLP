/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Repayment schedule report')                  */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                       */
/*                                                                  */
/*       LEC0865 - REPAYMENT SCHEDULE REPORT                        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 088019             Date 12Jun95              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*   088019 - Clear file LEREPSPD before calling LE0865             */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,LEC0865001                                          */
 
/* CALL LE0865 TWICE - FOR REPORTS BOTH BY BRANCH AND CONSOLIDATED  */
 
             CHGJOB     SWS(1XXXXXXX)
             CLRPFM     FILE(LEREPSPD)                                /*088019*/
             MONMSG     MSGID(CPF0000)                                /*088019*/
             CALL       PGM(LE0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))
 
/************CHGJOB*****SWS(X1XXXXXX)*******************************/ /* 0089 */
             CHGJOB     SWS(01XXXXXX)                                 /* 0089 */
             CLRPFM     FILE(LEREPSPD)                                /*088019*/
             MONMSG     MSGID(CPF0000)                                /*088019*/
             CALL       PGM(LE0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))
/*/COPY WNCPYSRC,LEC0865002                                          */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(END))
 
/* IF THERE ARE ERRORS OUTPUT THE DETAILS TO THE MESSAGE QUEUE */
 
   ERROR:
   RTVDTAARA DTAARA(LDA) RTNVAR(&LDA)
   MONMSG     MSGID(CPF0000)                                          /*088019*/
            CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                               TOMSGQ(MOPERQ)
                   MONMSG     MSGID(CPF0000)                          /*088019*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                               TOPGMQ(*EXT)
                   MONMSG     MSGID(CPF0000)                          /*088019*/
   END:
             CLRPFM     FILE(LEREPSPD)                                /*088019*/
             MONMSG     MSGID(CPF0000)                                /*088019*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
   ENDPGM
