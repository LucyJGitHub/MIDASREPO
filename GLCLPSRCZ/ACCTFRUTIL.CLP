/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Transfer Utility COB Component')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       ACCTFRUTIL - Midas GL Account Transfer Utility COB component*/
/*                                                                   */
/*       This calls the Account Transfer Utilities GLC003600 and     */
/*       GLC003700 during input cycle initiation.                    */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CGL114  *CREATE    Date 04Jan10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL114 - Account Transfer Utility                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2010')
             DCL        VAR(&REQD) TYPE(*CHAR) LEN(1)
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(ACCTFR (1 1)) RTNVAR(&REQD)
 
             IF         COND(&REQD = 'Y') THEN(DO)
 
             CALL GLC003600
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             CALL GLC003700
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGDTAARA  DTAARA(ACCTFR) VALUE('N')
             ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
