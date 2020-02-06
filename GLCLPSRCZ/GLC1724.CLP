/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Posting Summary Processing')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1724 - Post Summary                                      */
/*                                                                   */
/*       (C) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CGL047 *Create     Date 27Jun06              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL047 - Midas Generic Posting Interface                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MISYS) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Finastra International Limited 2006')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Open query with account as key */
             OPNQRYF    FILE((GLPSUMPD *FIRST)) FORMAT(*FILE) +
                          KEYFLD((BRCA) (CNUM) (CCY) (ACOD) (ACSQ) +
                          (DRCR))
 
/* Call summary program */
             CALL       PGM(GL1724)
 
/* Close query file */
             CLOF       OPNID(GLPSUMPD)
 
/* Database error  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination processing  */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&MISYS) VALUE('(C) Finastra International +
                          Limited 2006')
             ENDPGM
