/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Generic Postings Interface Shadow Post')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1725 - Generic Posting Interface Shadow Posting          */
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
 
/* Set job switch settings */
             CHGJOB     SWS(10000000)
 
/* Clear files */
             CLRPFM     FILE(GESGPIHH)
             CLRPFM     FILE(GESGPIPD)
             CLRPFM     FILE(GESGPIZZ)
             CLRPFM     FILE(GLPSUMPD)
             CLRPFM     FILE(GLGPIKPD)
 
/* Call program to generate account keys */
             CALL       PGM(GL1722)
 
/* Databse error in GL1722 */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Override postings files to shadow postings files */
             OVRDBF     FILE(GEGPIHH) TOFILE(GESGPIHH)
             OVRDBF     FILE(GEGPIPD) TOFILE(GESGPIPD)
             OVRDBF     FILE(GEGPIZZ) TOFILE(GESGPIZZ)
 
/* Call GL1723 to generate shadow postings */
             CALL       PGM(GL1723) PARM('S' 'N')
 
/* Data base error  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Delete overrides  */
             DLTOVR     FILE(GEGPIHH)
             DLTOVR     FILE(GEGPIPD)
             DLTOVR     FILE(GEGPIZZ)
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination processing  */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&MISYS) VALUE('(C) Finastra International +
                          Limited 2006')
             ENDPGM
