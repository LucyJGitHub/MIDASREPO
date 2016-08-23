/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Outgoing messages released summary')            */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0850 - OUTGOING MESSAGES RELEASED SUMMARY               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CCB023B            Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No.  X00000           DATE 00XXX00              */
/*                       X00000           DATE 00XXX00              */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       CCB023B - COB Restructure - Input Cycle Termination         */
/*                 Restructuring                                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&RUND)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBIN)  TYPE(*CHAR) LEN(1)
/* Copyright in object */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Variable for Message from LDA */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             MONMSG     MSGID(CPF0000)
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('OUTGOING MESSAGES RELEASED SUMMARY') +
                          TOMSGQ(MRUNQ)
 
/* Set-off database error switches */
             CHGJOB     SWS(XXXXXX00)
 
/* Access data area rundat for the Run date */
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUND)
 
             CPYF       FROMFILE(QTEMP/MGOREFPD) +
                          TOFILE(QTEMP/MGOREFLQ) CRTFILE(*YES) +
                          INCREL((*IF RELD *EQ ' '))                                     /*CCB023B*/
             MONMSG     MSGID(CPF0000)                                                   /*CCB023B*/
             OPNQRYF    FILE((QTEMP/MGOREFLQ)) +
                          KEYFLD((RELD) (BRCA) (MTPY))                                   /*CCB023B*/
                                                                                         /*CCB023B*/
/* Call Outgoing messages released summary RPG - System level*/
             CALL    PGM(ME0850) PARM('     ' 'S' '   ' &RUND)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
/* If system is multibranched then produce branch 'ALL' report */
    RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
 
    IF     COND(&MBIN = 'Y') THEN(DO)
 
/* Call Outgoing messages released summary RPG - Branch 'ALL'*/
             CALL    PGM(ME0850) PARM('     ' 'B' 'ALL' &RUND)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
    ENDDO
 
    GOTO END
 ERR:        SNDPGMMSG  MSG('Outgoing Messages released summary ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLTOVR     FILE(*ALL)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             MONMSG MSGID(CPF0000 MCH0000)
             ENDPGM
