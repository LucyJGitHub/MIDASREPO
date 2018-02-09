/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ABS ER Set off 'on request' LMI extract')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting                                  */
/*                                                                   */
/*       ERC1002 - ER Set off 'on request' LMI extract               */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX004             Date 27May97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX004 - Capital Adequacy                                   */
/*                                                                   */
/*********************************************************************/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('ERC1002 - Set off ''on request'' LMI +
                          extract') TOMSGQ(MRUNQ)
 
             CALL       PGM(ER1002)
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERC1002 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&MKICPY) VALUE('(c) Finastra International +
                          Limited 2005')
             ENDPGM
