/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE ON REQUEST REPORTING')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*                 LEC08 - ON REQUEST REPORTING                     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194             Date 11Dec89              */
/*                      S01117             Date 07Feb90              */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01117 - REL.10 MULTIBRANCHING                             */
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&PARM)                                  * *S01117*/
             PGM PARM(&PARM &RSEQ &RLEV &RENT)                        /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)             */  /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/************DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/**/
             CHGJOB     SWS(00000000)
/**/
/************CALL       PGM(&PARM)                              */    /*S01117*/
             CALL       PGM(&PARM) PARM(&RSEQ &RLEV &RENT)            /*S01117*/
/**/
/*   ERROR MESSAGES                                             */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*  CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))            */ /*S01194*/
    CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))               /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('FILE CONTROLS OUT OF +
                                            BALANCE')
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
