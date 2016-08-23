/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Monthly Processing Reporting')               */
/********************************************************************/
/*                                                                  */
/*       Midas     - Customer Lending Module                    */
/*                                                                  */
/*       LEC10A - MONTHLY PROCESSING REPORTING                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117                DATE 13/02/90         */
/*                                                                  */
/********************************************************************/
/*      S01117 - MULTIBRANCHING REL.10                              */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM &CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**/
             CHGJOB     SWS(00000000)
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
             IF         COND(%SUBSTRING(&LESTAT 13 1) *NE 'Y') +
                        THEN(GOTO CMDLBL(ENDPGM))
                CALL       PGM(&PARM) PARM(&CNAM &CSEQ)
/**/
/*   ERROR MESSAGES                                             */
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*********      CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))*/ /*S01117*/
                   CHGVAR    VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50)) /*S01117*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                ENDDO
/**/
                IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('FILE CONTROLS OUT OF +
                                               BALANCE')
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
                ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:         ENDPGM
