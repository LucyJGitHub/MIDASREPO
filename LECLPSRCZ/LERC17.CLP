/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Fees Settled/Adjusted Today Report')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LERC17  - Fees settled/adjusted today report                */
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
/*       Prev Amend No. 095606             Date 17Jun96              */
/*                      MOF60              Date 23Mar92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       095606 - Must move the clearing of LEFEEAD to LERC135       */
/*                as fix 045700 made this program run first before   */
/*                LERC135.                                           */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
                          Finastra International Limited')
 
ENDPGM
