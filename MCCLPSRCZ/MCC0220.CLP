/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Control Recreate Management A/cs')           */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                      */
/*                                                                   */
/*   MCC0220 - Control Recreation of Management Accounts             */
/*             from Movements                                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. XXXXXX     DATE DDMMMYY                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                      */
/*                                                                   */
/*********************************************************************/
 
/*   Job switch use                                                  */
 
/*   U7 - Database error                                             */
/*   U8 - Database error                                             */
 
             PGM        PARM(&GCD &PYR &PNO &RET)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&GCD) TYPE(*CHAR) LEN(2) /* Group code */
             DCL        VAR(&PYR) TYPE(*CHAR) LEN(4) /* Period year */
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(2) /* Period +
                          number */
             DCL        VAR(&RET) TYPE(*CHAR) LEN(1) /* Return code */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) /* Error +
                          message variable */
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* Reset job switches U7 and U8                                      */
             CHGJOB     SWS(XXXXXX00)
 
/* Call MC0220, passing parameters                                   */
             CALL       PGM(MC0220) PARM(&GCD &PYR &PNO &RET)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR     VAR(&RET) VALUE('Y')
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Recreate Management Accounts ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&RET) VALUE('Y')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:     ENDPGM
