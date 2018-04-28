/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('WHT Initialisation')                                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0204 - Tiered Withholding Tax Initilisation              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2006           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL013  *CREATE    Date 08Jun06              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDL013 - Tiered Withholding Tax                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &MODE)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2006')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(XXXXXX00)
/**/
/* Mode is blank */
/**/
             IF         COND(&MODE *EQ '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/*                                                                   */
/* If CAR is switched on (i.e. mode 1 or 2)                          */
/*                                                                   */
             IF         COND((&MODE *EQ '1') *OR (&MODE *EQ '2')) +
                          THEN(DO)
/*                                                                   */
/* Start journalling extension files PF/SDSTAXPA & PF/SDACODPA to    */
/* journal ICJRN.                                                    */
/* If file is already journalled continue processing.                */
/*                                                                   */
             STRJRNPF   FILE(*LIBL/SDSTAXPA) JRN(*LIBL/ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(*LIBL/SDACODPA) JRN(ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
 
             ENDDO
/*                                                                   */
/*                                                                   */
/* Call Utility programs with parameter (&MODE)                      */
/*                                                                   */
             CALL       PGM(GL0205) PARM(&MODE)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
             CALL       PGM(GL0206) PARM(&MODE)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
             CALL       PGM(GL0207) PARM(&MODE)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
             CALL       PGM(GL0208) PARM(&MODE)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
             CALL       PGM(GL0209) PARM(&MODE)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
             CALL       PGM(GL0210) PARM(&MODE)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
/*                                                                   */
                 RGZPFM     FILE(SDACODPA)
                 MONMSG     MSGID(CPF2981)
 
             GOTO END
 
 ABNOR:      CHGVAR     VAR(&RTNCDE) VALUE('*ERROR')
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
