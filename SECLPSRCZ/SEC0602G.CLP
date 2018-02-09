/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Clear Input Cycle Fields')                   */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*         SEC0602G - CLEAR INPUT CYCLE DATA                        */
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
/*       Prev Amend No. S01117             Date 10Dec90              */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*         S01117 - MULTIBRANCHING                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*           DCL VAR(&MEM) TYPE(*CHAR) LEN(44)                         *S01117*/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
/**/
/*           DCLDTAARA DTAARA(LDA)                                  *  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             SNDPGMMSG  MSG('SEC0602G - Clear Input Cycle Nominal Amounts') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
             CALL       PGM(SE2115)
/**/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RCVDTAARA  DTAARA(LDA)                                 *  *S01179*/
             RTVDTAARA  DTAARA(LDA)  RTNVAR(&LDA)                     /*S01179*/
/*           CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))             *S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('SEC0602G - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MRUNQ)
             ENDDO
/**/
/*   FILE CONTROL ERROR                                          */
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                          MSG('SEC0602G - File Controls out of +
                          Balance') TOPGMQ(*EXT) TOMSGQ(MRUNQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
