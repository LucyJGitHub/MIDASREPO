/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ RTALM subset extract parameters')            */
/********************************************************************/
/*                                                                  */
/*                  Midas Midas/Q Module                    */
/*                                                                  */
/*          MQ553XC - MIDAS/Q SUBSET EXTRACT PARAMETERS             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*          Last Amendment No. XXXXXX           Date. 99/XXX/99     */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*      XXXXXX - dddddddddddddddddddddddddddddddddddddddddddddddddd */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* SET OFF JOB SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CALL EXTRACT PARAMETERS INPUT PROGRAM */
             CALL       PGM(MQ553X)
 
/* IF ERROR HAS OCCURRED IN ACCESSING DATA AREA MQSEL, SEND MESSAGE */
/* TO USER                                                          */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('MIDAS/Q SUBSET EXTRACT PARAMETERS +
                           BEING UPDATED BY ANOTHER USER') TOPGMQ(*EXT)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
