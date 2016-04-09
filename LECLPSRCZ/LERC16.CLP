/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Fees Due For Settlement Report')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC16  - Fees due for settlement                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. CLE139             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. MOF60              DATE 23Mar92              */
/*                                         DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE139 - Lending Fee Capitalisation                         */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     SNDPGMMSG  MSG('Fees Due For Settlement') TOMSGQ(MRUNQ)
 
 /** Override LER160P2 attributes to increase width to 198 */                             /*CLE139*/
                                                                                          /*CLE139*/
             OVRPRTF    FILE(LER160P2) PAGESIZE(66 198) FORMTYPE(*STD) +
             OUTQ(*JOB) SAVE(*NO) SHARE(*YES)                                             /*CLE139*/
                                                                                          /*CLE139*/
             CALL       LER160
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
