/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Incoming Messages Review')                      */
/********************************************************************/
/*                                                                  */
/*     Midas Midas/S.W.I.F.T. DIRECT LINK                       */
/*                                                                  */
/*     MSC1021 - INCOMING MESSAGES REVIEW                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO.  00               DATE  00/00/00              */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                    */
/*                                                                  */
/********************************************************************/
             PGM
/*                                                                   */
/* Declare Message Detail Field.                                     */
/*                                                                   */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/*                                                                   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*                                                                   */
/* Set-off Data Base Error Switches.                                 */
/*                                                                   */
             CHGJOB     SWS(XXXXXX00)
/*                                                                   */
/* Call Input Cycle Review Program.                                  */
/*                                                                   */
             CALL       PGM(MS1021)
/*                                                                   */
/* For Database Errors Recover Data From Local Data Area, Send       */
/* Message to MOPERQ.                                                */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/*                                                                   */
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Incoming S.W.I.F.T Messages Review +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
 END:        RCLRSC
             ENDPGM
