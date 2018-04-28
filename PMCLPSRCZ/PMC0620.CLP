/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Start up group job 'PORTFOLIO '')            */
/********************************************************************/
/*                                                                  */
/*       Midas     PORTFOLIO MANAGEMENT MODULE                      */
/*                                                                  */
/*       PMC0620 START UP GROUP JOB 'CUSTOMER'                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 092963            DATE  18SEP95             */
/*       PREV AMEND NO. S01486            DATE  07JUL94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       092963  -  Clear *LDA after enquiry                        */
/*       S01486  -  Portfolio Management Upgrade                    */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
/*/COPY WNCPYSRC,PMC0620001                                          */
/**/
/* CHANGE JOB ATTRIBUTES TO BECOME GROUP JOB */
/*S01486 BEGIN*/
/*********** CHGGRPA    GRPJOB(CUSTOMER) TEXT('Group job for customer +
                          choice') */
/*S01486 END*/
/**/
/* PERFORM FILE OVERRIDES                                            */
/*S01486 BEGIN*/
/*********** OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPP) SHARE(*NO)**/
/*********** OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPP) SHARE(*NO)**/
             OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPD) SHARE(*NO)
             OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPD) SHARE(*NO)
/*S01486 END*/
/**/
/* RECEIVE NAME OF USER CURRENTLY SIGNED ON  */
             RTVJOBA    USER(&USER)
/**/
             CALL       PGM(PM0620) PARM(&USER) /* Call PM0620 to +
                          allow customer selection */
                                                                      /*092963*/
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')                       /*092963*/
/**/
/** DATABASE ERROR REPORTING                                        **/
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Program PMC0620 ended abnormally - job +
                          cancelled') TOMSGQ(MOPERQ)
                ENDDO
                                                                      /*092963*/
/*S01486 BEGIN*/
/*********** CHGGRPA    GRPJOB(*NONE)  */
/*S01486 END*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,PMC0620002                                          */
ENDPGM
/********ENDPGM                                                      */
