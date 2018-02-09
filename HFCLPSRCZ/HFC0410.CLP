/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Build string for event-processing')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0410  - BUILD STRING FOR EVENT PROCESSING                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend N0. S01379             DATE 17SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&X &Y &JNSEQ &XOLD &CHGOLD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&COUN) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&X) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&Y) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&XOLD) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&JNSEQ) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&JNSEQX) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHG) TYPE(*CHAR) LEN(13)
             DCL        VAR(&CHGOLD) TYPE(*CHAR) LEN(13)
             DCL        VAR(&#X) TYPE(*CHAR) LEN(5000)
             DCLF       FILE(HFFILEPD)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&JNSEQX) VALUE(&JNSEQ)
 
 
/* */
/* Get last change date of HFFILEPD   */
/* */
             RTVMBRD    FILE(HFFILEPD) CHGDATE(&CHG)
 
/* */
/* If file has changed then store change date */
/* */
             IF         COND(&CHG *NE &CHGOLD) THEN(DO)
             CHGVAR     VAR(&CHGOLD) VALUE(&CHG)
             CHGVAR     VAR(&X) VALUE(&#X)
             CHGVAR     VAR(&Y) VALUE(&#X)
             GOTO       CMDLBL(RETRY)
             ENDDO
 
/* */
/* If count is 50 then goto RCVJRNE */
/* */
             IF         COND(&XOLD *EQ '50') THEN(GOTO CMDLBL(LB50))
 
/* */
/* Save the counter */
/* */
             CHGVAR     VAR(&X) VALUE(&XOLD)
             GOTO       CMDLBL(SUITE)
 
/* */
/* Read the next record */
/* */
 RETRY:      RCVF
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(SUITE))
 
/* */
/* If not enabled then goto next record */
/* */
             IF         COND(&ENAB *NE 'E') THEN(GOTO CMDLBL(RETRY))
 
/* */
/* If the physical file does not exist, retry */
/* */
             CHKOBJ     OBJ(*LIBL/&FFORM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))
 
/* */
/* Increment the counter */
/* */
             CHGVAR     VAR(&COUN) VALUE(&COUN + 1)
 
/* */
/* If count is greater than 50 then goto RCVJRNE */
/* */
             IF         COND(&COUN *GT 50) THEN(GOTO CMDLBL(LB50))
 
/* */
/* Build substitution variable for the RCVJRNE cmd */
/* */
             CHGVAR     VAR(&X) VALUE(&X *BCAT '(*LIBL/' *TCAT +
                          &FFORM *TCAT ' *ALL)')
 
/* */
/* Read next record */
/* */
             GOTO       CMDLBL(RETRY)
SUITE:
             CHGVAR     VAR(&XOLD) VALUE(&X)
 
/* */
/* Build substitution variable for the RCVJRNE cmd */
/* */
/************CHGVAR     VAR(&Y) VALUE('RCVJRNE JRN(ICJRN) +
                          RCVRNG(ICRCV001 *CURRENT) EXITPGM(HF0400) +
                          FROMENT(' *CAT &JNSEQX *CAT ') +
                          TOENT(*LAST) JRNCDE(R) FILE(' *BCAT &X +
                          *BCAT ')')********************************************************CSC020*/
             CHGVAR     VAR(&Y) VALUE('RCVJRNE JRN(ICJRN) +
                          RCVRNG(*CURCHAIN) EXITPGM(HF0400) +
                          FROMENT(' *CAT &JNSEQX *CAT ') +
                          TOENT(*LAST) JRNCDE(R) FILE(' *BCAT &X +
                          *BCAT ')')                                                      /*CSC020*/
 
/* */
/* Build substitution variable for the RCVJRNE cmd */
/* */
/************CHGVAR     VAR(&X) VALUE('RCVJRNE JRN(ICJRN) +
                          RCVRNG(ICRCV001 *CURRENT) EXITPGM(HF0400) +
                          TOENT(*LAST) JRNCDE(R) FILE(' *BCAT &X +
                          *BCAT ')')********************************************************CSC020*/
             CHGVAR     VAR(&X) VALUE('RCVJRNE JRN(ICJRN) +
                          RCVRNG(*CURCHAIN) EXITPGM(HF0400) +
                          FROMENT(' *CAT &JNSEQX *TCAT ') +
                          TOENT(*LAST) JRNCDE(R) FILE(' *BCAT &X +
                          *BCAT ')')                                                      /*CSC020*/
             GOTO END
 
LB50:
 
/* */
/* Build substitution variable for the RCVJRNE cmd */
/* */
/************CHGVAR     VAR(&X) VALUE('RCVJRNE JRN(ICJRN) +
                          RCVRNG(ICRCV001 *CURRENT) EXITPGM(HF0400) +
                          TOENT(*LAST) JRNCDE(R)')******************************************CSC020*/
             CHGVAR     VAR(&X) VALUE('RCVJRNE JRN(ICJRN) +
                          RCVRNG(*CURCHAIN) EXITPGM(HF0400) +
                          TOENT(*LAST) JRNCDE(R)')                                        /*CSC020*/
 
/* */
/* Build substitution variable for the RCVJRNE cmd */
/* */
/************CHGVAR     VAR(&Y) VALUE('RCVJRNE JRN(ICJRN) +
                          RCVRNG(ICRCV001 *CURRENT) EXITPGM(HF0400) +
                          FROMENT(' *CAT &JNSEQX *CAT ') +
                          TOENT(*LAST) JRNCDE(R)')******************************************CSC020*/
             CHGVAR     VAR(&Y) VALUE('RCVJRNE JRN(ICJRN) +
                          RCVRNG(*CURCHAIN) EXITPGM(HF0400) +
                          FROMENT(' *CAT &JNSEQX *CAT ') +
                          TOENT(*LAST) JRNCDE(R)')                                        /*CSC020*/
 
             CHGVAR     VAR(&XOLD) VALUE('50')
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0410 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
