/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Monthly Processing Reporting')               */
/********************************************************************/
/*                                                                  */
/*       Midas     - Customer Lending Module                    */
/*                                                                  */
/*       LEC10A - MONTHLY PROCESSING REPORTING                      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD031285           Date 15Jun16              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 13/02/90             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*      MD031285 - LE Guarantee was not expired on end date.        */
/*      S01117 - MULTIBRANCHING REL.10                              */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM &CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
/**********  IF         COND(%SUBSTRING(&LESTAT 13 1) *NE 'Y') +
                        THEN(GOTO CMDLBL(ENDPGM))               */                     /*MD031285*/
             IF         COND(%SUBSTRING(&LESTAT 13 1) *NE 'Y' *AND +
                          &CSEQ *NE 8) THEN(GOTO CMDLBL(ENDPGM))                       /*MD031285*/
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
                          Finastra International Limited')
ENDPGM:         ENDPGM
