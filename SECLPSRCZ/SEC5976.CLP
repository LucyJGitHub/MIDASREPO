/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Security Market Prices Enquiry')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5976 - Security Market Prices Enquiry                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01502 *CREATE     Date 08Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       S01502 - BLI Telekurs Processing.                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
/**/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             IF         COND(%SST(&SESTAT 129 1) *EQ 'N') THEN(GOTO +
                          CMDLBL(END))
/**/
             CHGDTAARA  DTAARA(LDA)   VALUE(' ')
             CHGJOB SWS(00000000)
/**/
/* Check if DTAARA/SESDS exists. If not, create it.                */
/**/
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37) +
                          VALUE('SE0976')
             ENDDO
/**/
/* Check that prices updated OK                                    */
/**/
             IF         COND((%SST(&SESTAT 130 2) *NE 'NN')) THEN(DO)
               SNDPGMMSG  MSG('Telekurs prices being updated') +
                            TOPGMQ(*EXT)
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/
             ELSE DO
               CHKOBJ     OBJ(QTEMP/EMSDS) OBJTYPE(*DTAARA)
               MONMSG     MSGID(CPF9800) EXEC(DO)
/**********      CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(161) */                   /*CGL029*/
                 CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(167)                      /*CGL029*/
                 CHGDTAARA  DTAARA(QTEMP/EMSDS) VALUE(' ')
               ENDDO
/**/
               CALL       PGM(SE5976)
             ENDDO
/**/
/* For database errors recover data from LDA                       */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
