/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Fee Accruals Report')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC18  - Fee Accruals report                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. BH3518             DATE 18SEP92              */
/*                      BH3504             DATE 27AUG92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BH3518  -  Make report run monthly, and on request          */
/*       BH3504  -  Fee accruals report added to system              */
/*                                                                   */
/*********************************************************************/
 
/****PGM****/
             PGM PARM(&RSEQ &LVL &RENT)                               /*BH3518*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*BH3518*/
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)                  /*BH3518*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*BH3518*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             SNDPGMMSG  MSG('Fee Accruals Report') TOMSGQ(MRUNQ)
 
             CALL       LER180
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
