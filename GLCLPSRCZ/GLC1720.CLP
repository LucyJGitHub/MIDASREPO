/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Generic Posting Interface Clear Files')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1720 - Clear Generic Postings Interface Work Files       */
/*                                                                   */
/*       (C) Misys Banking Systems Ltd. 2006                         */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CGL047 *Create     Date 30Jun06              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
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
 
/* Clear files  */
             CLRPFM     FILE(GEGPIHH)
             CLRPFM     FILE(GEGPIPD)
             CLRPFM     FILE(GEGPIZZ)
             CLRPFM     FILE(GESGPIHH)
             CLRPFM     FILE(GESGPIPD)
             CLRPFM     FILE(GESGPIZZ)
             CLRPFM     FILE(GLICHKPD)
             CLRPFM     FILE(GLPCHKPD)
             CLRPFM     FILE(GLPCHKPA)
             CLRPFM     FILE(GLGPIPPD)
             CLRPFM     FILE(GLGPIKPD)
             CLRPFM     FILE(GLPSUMPD)
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination processing  */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&MISYS) VALUE('(C) Misys Banking +
                          Systems Ltd. 2006')
             ENDPGM
