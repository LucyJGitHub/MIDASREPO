/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG For cust defn dta extr called in RPG src')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondent Module                   */
/*                                                                   */
/*       CGC3606 - Customed Defined Data Extract called              */
/*                 in an RPG program                                 */
/*       This is done in order to fill a return code that            */
/*       can be trapped by the RPG program                           */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CCG015  *CREATE    Date 14Jan02              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCG015 - Correspondence Manager                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETURN)
 
/*/COPY WNCPYSRC,mmCnnnnINT                                          */
 
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,mmCnnnnMPS                                          */
 
/* Check if Correspondence manager is switched on */
/* Do nothing if it is off */
             CHGVAR     VAR(&RETURN) VALUE('       ')
             CHGVAR     VAR(&OPTION) VALUE('*VERIFY')
             CHGVAR     VAR(&SARNBR) VALUE('CCG015')
 
             CALL       PGM(AOSARDR0) PARM(&RETURN &OPTION &SARNBR +
                          &SARFMT)
 
             IF         COND(&RETURN *NE '       ') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 
             CALL       PGM(CGC3604)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&RETURN) VALUE('*ERROR')
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,mmCnnnnERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&RETURN) VALUE('*ERROR')
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            CGC3606 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,mmCnnnnEND                                          */
 
/* (Add any specific end processing here) */
 
             ENDPGM
