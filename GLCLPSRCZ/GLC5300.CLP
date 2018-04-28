/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Generated entries component')                */
/********************************************************************/
/*                                                                  */
/*       Midas Standing Data Module                         */
/*                                                                  */
/*       GLC5300 - GENERATED ENTRIES COMPONENT                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408            DATE 04MAY95              */
/*       PREV AMEND NO. Ennnnn            DATE ddmmmyy              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01408 -  CORE HOOK ADDED GLC5300MP1                      */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*                                                                      */
             PGM        PARM(&POST &CNAM &CSEQ)
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
/*                                                                      */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/**/
/* Set-off Database Error Switches and clear LDA */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA  (134 50)) VALUE(' ')
/**/
/* Clear down relevant output files depending on whether this is*/
/* a normal run or an ANWD run*/
/**/
             IF COND(&POST *EQ '1') THEN(DO)
             CLRPFM     FILE(GENAPD)
             CLRPFM     FILE(GENAZZ)
             CLRPFM     FILE(GEHMPD)
             CLRPFM     FILE(GEHMZZ)
             ENDDO
/**/
             IF COND(&POST *EQ '5') THEN(DO)
             CLRPFM     FILE(GENA2PD)
             CLRPFM     FILE(GENA2ZZ)
             CLRPFM     FILE(GEHM2PD)
             CLRPFM     FILE(GEHM2ZZ)
             ENDDO
/**/
/* Call CB0160 */
/**/
             CHGVAR     VAR(&STAT) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
/* If this is a restart, copy back up files to master files   */
/* for retry of component*/
/**/
             IF COND(&STAT *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(SDCSFDPDX) TOFILE(SDCSFDPD) +
                          MBROPT(*REPLACE)
/**/
/* Change status flag to 'N'*/
/**/
             CHGVAR     VAR(&STAT) VALUE('N')
/**/
/* Call CB0150, update restart indicator */
/**/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/**/
/* Set up library prefix from SDSTAT */
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*S01147*/
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC5300MP1                                          */
                                                                      /*S01408*/
 
/**/
/* Create security copy */
/**/
             CPYF       FROMFILE(SDCSFDPD) TOFILE(&DPLIB/SDCSFDPDX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
/**/
/* Change status flag to 'Y'*/
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
/**/
/* If this is an ANWD run, override to correct output files */
/**/
             IF COND(&POST *EQ '5') THEN(DO)
             OVRDBF     FILE(GEHMPD) TOFILE(GEHM2PD)
             OVRDBF     FILE(GEHMZZ) TOFILE(GEHM2ZZ)
             OVRDBF     FILE(GENAPD) TOFILE(GENA2PD)
             OVRDBF     FILE(GENAZZ) TOFILE(GENA2ZZ)
             ENDDO
/**/
/* Call CB0150, update restart indicator */
/**/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**/
/* Call GL5300, generated entry program */
/**/
             CALL       PGM(GL5300)
/**/
/* If call successful */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/* Change status flag to 'Y'*/
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
/**/
/* Call CB0150, update restart indicator */
/**/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**/
/* Delete back up files */
/**/
             DLTF SDCSFDPDX
             GOTO       CMDLBL(END)
 
             ENDDO
/**/
/* If database error send error message*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA DTAARA(&LDA  (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             GOTO CMDLBL(ABNOR)
             ENDDO
 
 ABNOR:      SNDPGMMSG  MSG('Job Terminated - Program error in +
                          Customer Fees entry generation') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                        CHGJOB   SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
