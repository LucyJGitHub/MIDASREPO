/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Reset Pending messages to RSND')                */
/*********************************************************************/
/*                                                                   */
/*     Midas - MESSAGE MANAGEMENT                            */
/*                                                                   */
/*     MEC0580 - RESET PENDING MESSAGES TO READY-TO-SEND             */
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
/*       Prev Amend No. E32330             Date 04Nov91              */
/*                      000000             Date 00Xx000              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     E32330 - BHF IMPLEMENTATION SPECIFIC CHANGES                  */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WKSTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*/COPY WNCPYSRC,MEC0580001                                          */
 
/* End direct-link communications */
             CALL       PGM(MSC4002)
/*/COPY WNCPYSRC,MEC0580002                                          */
 
/* Wait for link to end */
             DLYJOB     DLY(60)
 
             RTVJOBA    JOB(&WKSTN) USER(&USRID)
             CHGJOB     SWS(XXXXXX00)
             OVRDBF     FILE(MGOREFA5) SHARE(*NO)
 
             CALL       PGM(ME0580)
 
/* Check for database errors */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ &WKSTN)
             ENDDO
 
/* User does not have Routing Officer authority */
             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(&USRID *bcat 'you do not +
                          have Routing Officer Authority')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ &WKSTN)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Reseting Pending messages to +
                          Amended ENDED ABNORMALLY') TOMSGQ(MOPERQ +
                          &WKSTN)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        CHGJOB     SWS(XXXXXX00)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
