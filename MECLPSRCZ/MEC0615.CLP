/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Block release of outgoing messages')            */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0615 - Block release of outgoing messages               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  X00000           DATE 00XXX00              */
/*       PREV AMEND NO.  X00000           DATE 00XXX00              */
/*                                                                  */
/********************************************************************/
/* This program has been written to facilitate the addition of new  */
/* block release functions. To create a block release funtion, add  */
/* a menu item which calls this program with parameters of:         */
/*   o  A logical file selecting only messages eligible for release */
/*   o  A (<49 character) title for the screen/report               */
/********************************************************************/
 
             PGM        PARM(&LF &TITLE)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TITLE) TYPE(*CHAR) LEN(49)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(ME0615) PARM(&LF &TITLE)
 
/* Check for database errors */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Block Release of Outgoing Messages +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
