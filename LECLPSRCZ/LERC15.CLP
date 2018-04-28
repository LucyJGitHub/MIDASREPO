/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Outstanding Fees Report')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC15  - Outstanding fees report                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 079434             DATE 21MAR96              */
/*       PREV AMEND NO. MOF60              DATE 23MAR92              */
/*                                                                   */
/*********************************************************************/
/*       079434 - Object lock caused GLC86 to fail.                  */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     SNDPGMMSG  MSG('Outstanding Fees Report') TOMSGQ(MRUNQ)
 
/*********   ALCOBJ     OBJ((ACCNT *FILE *EXCL)) WAIT(32767)            079434*/
/*********   DLCOBJ     OBJ((ACCNT *FILE *EXCL))                        079434*/
             ALCOBJ     OBJ((ACCNT *FILE *EXCLRD)) WAIT(32767)        /*079434*/
             DLCOBJ     OBJ((ACCNT *FILE *EXCLRD))                    /*079434*/
 
             CALL       LER150
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
