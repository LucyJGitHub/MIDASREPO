/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Fees Settled/Adjusted Today Report')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LERC17  - Fees settled/adjusted today report                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 095606             DATE 17JUN96              */
/*       PREV AMEND NO. MOF60              DATE 23MAR92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       095606 - Must move the clearing of LEFEEAD to LERC135       */
/*                as fix 045700 made this program run first before   */
/*                LERC135.                                           */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     SNDPGMMSG  MSG('Fees Settled/Adjusted Today') TOMSGQ(MRUNQ)
 
             CALL       LER170
 
     IF COND(%SWITCH(XXXXXX11))   THEN(DO)
             SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
     ENDDO
/*** ELSE DO */                                                       /*095606*/
/*** CLRPFM LEFEEAD */                                                /*095606*/
/*** ENDDO */                                                         /*095606*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
