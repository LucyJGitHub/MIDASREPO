/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Change FF mkt status: act/failed')           */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Restart Recovery Module                   */
/*                                                                   */
/*     SDC1744 - SET ACTIVE END OF CENTRES TO FAILED                 */
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
/*     PREV AMEND NO. 00                 DATE 00/00/00               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&NOMSG) TYPE(*CHAR) LEN(1) VALUE('0')
/**/
             DCLF       FILE(MKCTL1)
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/* PROCESS EVERY MARKET IN END OF CENTRE                             */
/**/
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(MSG))
/**/
/* SET FLAG TO SHOW AT LEAST ONE MESSAGE HAS BEEN SENT               */
/**/
             IF         COND(&NOMSG *EQ '0') THEN(CHGVAR +
                                VAR(&NOMSG) VALUE('1'))
/**/
/* SET ALL ACTIVE MARKETS THAT HAD NOT ALREADY FAILED TO FAILED      */
/**/
                IF         COND(&ECFI *NE 'F') THEN(DO)
                   CALL       PGM(FF0472) PARM('F' &MRKT)
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNOR)
/**/
/* SEND A MESSAGE TO THE MONITOR FILE FOR THE MARKET EOC THAT HAS    */
/* BEEN FAILED                                                       */
/**/
                   CALL       PGM(FF0473) PARM(&MRKT 'I' 'End +
                                Of Centre for market set to FAILED +
                                at recover to point            ')
                ENDDO
/**/
                GOTO       CMDLBL(READ)
/**/
/* IF ANY EOCS WERE ACTIVE SEND WARNING MESSAGE TO MOPERQ            */
/**/
MSG:            IF        COND(&NOMSG *EQ '1') THEN(SNDPGMMSG +
                          MSG('End Of Centres in failed state at +
                          recover to point. Run End Of Centre +
                          recovery') TOPGMQ(*EXT) TOMSGQ(MOPERQ))
/**/
/* CANCEL ANY REQUESTS FOR HOLDING ANY EOCS                          */
/**/
                CALL       PGM(SDC1745)
/**/
                GOTO       CMDLBL(END)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
 ABNOR:         SNDPGMMSG  MSG('PROGRAM SDC1744 - Set markets with +
                          active EOCs to failed - ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CHGJOB     SWS(XXXXXX1X)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:            ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
