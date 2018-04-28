/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RC II - Create ledger details')                 */
/********************************************************************/
/*                                                                  */
/*       Midas     - Automatic Reconciliations II               */
/*                                                                  */
/*       RCC2010 - Create Ledger Details - CoB                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No.  CDL030           Date 10Dec04               */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No.  S01449           Date 07Jan94               */
/*                       X00000           Date 00XXX00               */
/*                                                                  */
/********************************************************************/
/*  CDL030 - MT950 Messages Linked to Deal Type / Sub Type          */
/*  S01449 - Created for AutoRecs II                                */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                   /*CDL030*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                   /*CDL030*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                 /*CDL030*/
             DCL        VAR(&CDL030) TYPE(*CHAR) LEN(1) VALUE('N')                       /*CDL030*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/** Check if CDL030 is on */                                                             /*CDL030*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                     /*CDL030*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                     /*CDL030*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN 'CDL030' +
                          &DSSDY)                                                        /*CDL030*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL030) VALUE('Y'))                                       /*CDL030*/
                                                                                         /*CDL030*/
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('AutoRecs II - Create Ledger Details') +
                          TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* CDL030 Not Set  */                                                                    /*CDL030*/
             IF         COND(&CDL030 *EQ 'N') THEN(DO)                                   /*CDL030*/
 
/* Clear work files */
             CLRPFM     FILE(RCLDGRBK)
             CLRPFM     FILE(RCLDGDBK)
 
/* Call RPG program */
             CALL       PGM(RC2010)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO END
             ENDDO
 
/* No error, so copy work files to masters */
             CPYF       FROMFILE(RCLDGRBK) TOFILE(RCLDGRPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817)
             CPYF       FROMFILE(RCLDGDBK) TOFILE(RCLDGDPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817)
 
/* Skip error processing */
             GOTO END
             ENDDO                                                                       /*CDL030*/
 
/* CDL030 is Set  */
             IF         COND(&CDL030 *EQ 'Y') THEN(DO)                                   /*CDL030*/
/* Allocate message reference file */                                                    /*CDL030*/
 TRY:        ALCOBJ     OBJ((MGOREFPD *FILE *EXCL)) WAIT(30)                             /*CDL030*/
             MONMSG     MSGID(CPF1619) EXEC(GOTO CMDLBL(TRY))                            /*CDL030*/
                                                                                         /*CDL030*/
/* Set up back up files */                                                               /*CDL030*/
             CLRPFM     FILE(MGOMSGBK)                                                   /*CDL030*/
             CLRPFM     FILE(MGOREFBK)                                                   /*CDL030*/
             CPYF       FROMFILE(MGOMSGPD) TOFILE(MGOMSGBK) +
                          MBROPT(*ADD)                                                   /*CDL030*/
             CPYF       FROMFILE(MGOREFPD) TOFILE(MGOREFBK) +
                          MBROPT(*ADD)                                                   /*CDL030*/
                                                                                         /*CDL030*/
/* Call SWIFT Statement production program */                                            /*CDL030*/
             CALL       PGM(RC2012)                                                      /*CDL030*/
                                                                                         /*CDL030*/
/* If program ends in error, clear down messages produced */                             /*CDL030*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(CLRF))                               /*E29588*/         /*CDL030*/
                                                                                         /*CDL030*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                             %SWITCH(XXXXXXX1)) THEN(DO)             /*101867*/          /*CDL030*/
 CLRF:       CLRPFM     FILE(MGOMSGPD)                                /*E29588*/         /*CDL030*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*CDL030*/
             CLRPFM     FILE(MGOREFPD)                                                   /*CDL030*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*CDL030*/
             CPYF       FROMFILE(MGOMSGBK) TOFILE(MGOMSGPD) +
                          MBROPT(*ADD)                                                   /*CDL030*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*CDL030*/
             CPYF       FROMFILE(MGOREFBK) TOFILE(MGOREFPD) +
                          MBROPT(*ADD)                                                   /*CDL030*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*CDL030*/
                                                                                         /*CDL030*/
             DLCOBJ     OBJ((MGOREFPD *FILE *EXCL))                                      /*CDL030*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*CDL030*/
             GOTO       CMDLBL(ERR)                                                      /*CDL030*/
             ENDDO                                                                       /*CDL030*/
                                                                                         /*CDL030*/
             GOTO       CMDLBL(END)                                                      /*CDL030*/
             ENDDO                                                                       /*CDL030*/
 
 ERR:        SNDPGMMSG  MSG('AutoRecs II - Create Ledger Details +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
