/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI Interface Monitor')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4430 - CI Interface Monitor                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 118134             Date 02Jun97              */
/*                      CRT003  *CREATE    Date 22Jul96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface.                                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CALL       PGM(RE4430)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               GOTO CMDLBL(END)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               ROLLBACK
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                 TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Interface Monitor Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF2469)  EXEC(DO)                      /*118134*/
                SNDPGMMSG  MSG('CI Interface Monitor Ended +
                             Abnormally') TOMSGQ(QSYSOPR)             /*118134*/
             ENDDO                                                    /*118134*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
