/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Generic Posting Interface Postings')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1723 - Create Postings                                   */
/*                                                                   */
/*       (C) Misys Banking Systems Ltd. 2006                         */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CGL047 *Create     Date 27Jun06              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL047 - Midas Generic Posting Interface                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MISYS) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Misys Banking Systems Ltd. 2006')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Reset job switches */
             CHGJOB     SWS(00000000)
 
/* Create LDA if it does not alredy exist  */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/* Clear files */
             CLRPFM     FILE(GEGPIHH)
             CLRPFM     FILE(GEGPIPD)
             CLRPFM     FILE(GEGPIZZ)
             CLRPFM     FILE(GLPSUMPD)
 
/* Call GL1723  */
             CALL       PGM(GL1723) PARM('N' 'Y')
 
/* Data base error  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Call summary Processing */
             CALL       PGM(GLC1724)
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination processing  */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&MISYS) VALUE('(C) Misys Banking +
                          Systems Ltd. 2006')
             ENDPGM
