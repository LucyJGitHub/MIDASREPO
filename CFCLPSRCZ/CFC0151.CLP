/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Resend confirmations to TRAM')               */
/*********************************************************************/
/*                                                                   */
/*     Midas - CONFIRMATION MATCHING                                 */
/*                                                                   */
/*     CFC0151 - RESEND DEALING CONFIRMATIONS TO TRAM                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CSW025             Date 06Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01310             Date 06Dec90              */
/*                       00000             Date 00XXX00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSW025 - Midas Message Manager                              */
/*     S01310 - SWIFT RATIONALISATION                                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                         /*CSW025*/
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW025*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
             CHGJOB     SWS(00000000)
 
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')                              /*CSW025*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW025) VALUE('Y'))                            /*CSW025*/
                                                                                          /*CSW025*/
/* Call main RESEND TO TRAM program */
/*/COPY WNCPYSRC,CFC0151001                                          */
             IF COND(&CSW025 *NE 'Y') THEN(DO)                                            /*CSW025*/
             CALL       PGM(CF0187)
             ENDDO                                                                        /*CSW025*/
/*/COPY WNCPYSRC,CFC0151002                                          */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO ABNOR
             ENDDO
 
             GOTO END
 ABNOR:      SNDPGMMSG  MSG('CFC0151 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
