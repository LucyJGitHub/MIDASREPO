/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE T&N Rate Override')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail T&N Accounts                             */
/*                                                                   */
/*       REC200100 - Midas RE Rate Override                          */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CRE015  *CREATE    Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       CRE015 - Retail Term and Notice Accounts                    */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RETCODE &SYS &CCY &DIC &DST &DNIR &CIC +
                             &CST &CNIR &VDT &DRCR &BALN &RAT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2010')
 
             DCL        VAR(&RETCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DIC) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&DST) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DNIR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CIC) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&CST) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CNIR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&VDT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DRCR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BALN) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&RAT) TYPE(*DEC) LEN(11 7)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('XXXPLIB   ')                                             /*CSC043*/
/**********               VALUE('XXXLIB    ')  */                                         /*CSC043*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(LDA) VALUE(*BLANKS)
             CHGVAR     VAR(&RAT) VALUE(00000000000)
 
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(%SST(&XLIB 1 2)) VALUE(&SYS)
 
             CALL       PGM(&XLIB/UPC0014) PARM(&SYS)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Program error in executing UPC0014') +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             CALL       PGM(RE200100) PARM(&RETCODE &CCY &DIC &DST +
                            &DNIR &CIC &CST &CNIR &VDT &DRCR &BALN &RAT)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Program error in RE200100') +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             GOTO       CMDLBL(ENDP)
 
ERROR:
             CHGVAR     VAR(&RETCODE) VALUE('*ERROR')
             SNDPGMMSG  MSG('Program REC200100 ended abnormally - see job log ') +
                          TOMSGQ(MOPERQ)
 
ENDP:
             ENDPGM
