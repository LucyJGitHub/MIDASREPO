/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Bal HO Ccy, by Co, GL level')                */
/*********************************************************************/
/*                                                                   */
/*       Midas  -  General Ledger Module                             */
/*                                                                   */
/*       CLP/GLC75E - GL Balances in HO ccy, by co, GL level         */
/*                                                                   */
/*       Function: To Generate the Consolidated Euro Position Report.*/
/*                                                                   */
/*       Called By: GLC740 - GL Balances in one Ccy; GL A/C level    */
/*                                                                   */
/*       Calls  :   GL0744 - GL Balances Sort for EMU - 1            */
/*                  GL0750 - GL Balances Report by account code      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU011 *Create     Date 11Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU011 - EMU Position/Risk Reporting                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RUNTYPE &RSEQ &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RUNTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
/*/COPY WNCPYSRC,GLC75E001                                           */
 
/** Global monitor message */
 
             MONMSG   MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
 
 
/**          Offsets for file indicators in the GLSTAT data area     */
 
             SNDPGMMSG  MSG('GLC75E - GL Balances in H.O. Ccy, +
                          by company, at GL level') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(10001XX0)
 
             OPNQRYF    FILE((GLEXGC) (SDCURRPD)) FORMAT(GLEXTRPD) +
                          KEYFLD((*MAPFLD/ECSS *ASCEND) +
                          (GLEXGC/CCY)) JFLD((GLEXGC/CCY +
                          SDCURRPD/A6CYCD)) MAPFLD((ECSS A6SSNB) +
                          (INCY A6INCY))
 
             CPYFRMQRYF FROMOPNID(GLEXGC) TOFILE(GLEXTRPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2909)
 
             CLOF       OPNID(GLEXGC)
 
             CLRPFM     FILE(GLX14)
             CALL       PGM(GL0744)  PARM(&RENT)
 
             OVRDBF     FILE(SGLEX) TOFILE(GLX14)
             MONMSG     MSGID(CPF0000)
 
 
/*/COPY WNCPYSRC,GLC75E002                                           */
             CALL       PGM(GL0750) PARM(&RUNTYPE &RSEQ &RENT)
/*/COPY WNCPYSRC,GLC75E003                                           */
 
 
             DLTOVR     FILE(SGLEX)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                             MSG('FILE OUT OF BALANCE - SGLEX') +
                             TOMSGQ(MOPERQ MRUNQ))
 
             GOTO       CMDLBL(END)
 
ABNOR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('GLC75E Ended abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG        MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
END:         ENDPGM
