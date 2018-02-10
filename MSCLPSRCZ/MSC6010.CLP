/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MS Merva/2 - Outgoing Messages Tx')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - SWIFT direct link                               */
/*                                                                   */
/*       MSC6010 - Merva/2 Outgoing Message Transmission             */
/*                                                                   */
/*       Written for S01431 - Midas to Merva/2 interface             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      089842             Date 19Dec97              */
/*                       Xnnnnn           DATE nnXXXnn               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   CCB020 - COB Restructure - Secondary COB Infrastructure         */
/*   089842 - Send a break message only if the program is running    */
/*            interactively, else just send a message to the msg     */
/*            queue.                                                 */
/*                                                                   */
/*********************************************************************/
 
/* Parameter &JOB used to send termination message to submitting w/s */
             PGM        PARM(&JOB)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NAR) TYPE(*CHAR) LEN(70)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/************DCL*VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +       */
/************COPYRIGHT MKI LIMITED 1993, 1994')                      */
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                          */ /*089842 CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/**Retrieve*MPHAS*Data*Area**/                                                     /*089842 CCB020*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*089842 CCB020*/
/**/                                                                                      /*CCB020*/
/** CBFLAGQT Phase Check  **/                                                             /*CCB020*/
/**/                                                                                      /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
                                                                      /*089842*/
/* Allocate data area MS6010 to show that program is active         */
             ALCOBJ     OBJ((MS6010 *DTAARA *EXCL))
 
/* Override API profile file to approriate member for MS6010        */
             OVRDBF     FILE(MSPRFOPD) MBR(PRF)
 
/* Create Local Data Area (LDA)                                     */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
 
/* Set-off Database Error Switches and set the Job run priority     */
             CHGJOB     RUNPTY(19) SWS(XXXXXX00)
 
/* Call MS6010 to begin communications with Merva/2 device          */
             CALL       PGM(MS6010) PARM(&RC &NAR)
 
/* If switches are on, process database error                       */
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)      */      /*089842*/
             IF         COND(%SWITCH(XXXXXX11) *AND (&RC *EQ +
                          'NOER')) THEN(DO)                           /*089842*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(GBMIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
/* If return code not 'NOER' error has occured, so send message to  */
/* submitting user's workstation                                    */
/* If program is running in batch, send the message to MOPERQ    */   /*089842*/
/* and MRUNQ instead.                                            */   /*089842*/
             IF         COND(&RC *NE 'NOER') THEN(DO)
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)                           */ /*089842 CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(DO)                                   /*CCB020*/
             SNDBRKMSG  MSG('Midas to Merva/2 Outgoing Transmission +
                          has terminated abnormally with error +
                          code:' *BCAT &RC *BCAT &NAR) TOMSGQ(&JOB)
             MONMSG     MSGID(CPF0000)
             ENDDO
             ELSE       CMD(DO)                                       /*089842*/
             SNDBRKMSG  MSG('Midas to Merva/2 Outgoing Transmission +
                          has terminated abnormally with error +
                          code:' *BCAT &RC *BCAT &NAR) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*089842*/
             MONMSG     MSGID(CPF0000)                                /*089842*/
             ENDDO                                                    /*089842*/
             ENDDO                                                    /*089842*/
                                                                      /*089842*/
 
             GOTO       CMDLBL(END)
 
 ERR:        SNDPGMMSG  MSG('Midas to Merva/2 Outgoing Transmission +
                          component ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:        DLCOBJ     OBJ((MS6010 *DTAARA *EXCL))
             MONMSG MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
