/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE REFERRAL REPORT')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC376B - REFFERAL REPORT - BOTH VERSIONS                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER055             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CGL002             Date 28Oct96              */
/*                      S01413 *CREATE     Date 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER055 - Penalty Interest on Exceeding Overdraft Limit      */
/*       CGL002 - Block GL Accounts in Journal Entry Input           */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)               /*CGL002*/
/**/                                                                  /*CGL002*/
/*/COPY WNCPYSRC,REH00059                                            */
             SNDPGMMSG  MSG('REC376B - Referral Report') TOMSGQ(MRUNQ)
                                                                                          /*CER055*/
 /** Override RE0761P1 attributes to increase width to 198 */                             /*CER055*/
                                                                                          /*CER055*/
             OVRPRTF    FILE(RE0761P1) PAGESIZE(66 198) FORMTYPE(*STD) +
                OUTQ(*JOB) SAVE(*NO) SHARE(*YES)                                          /*CER055*/
                                                                                          /*CER055*/
             OVRDBF     FILE(TABLE) TOFILE(TABRE2)
/**/                                                                  /*CGL002*/
             CALL       PGM(AOMMODR0) PARM('*DBERR' '*FIRST' &MMOD)   /*CGL002*/
/**/                                                                  /*CGL002*/
/**  Run Retail Referral report only if Retail module is present   */ /*CGL002*/
/**/                                                                  /*CGL002*/
             IF         COND(%SST(&MMOD 29 1) *EQ 'Y') THEN(DO)       /*CGL002*/
/*/COPY WNCPYSRC,REH00060                                            */
             CALL       PGM(RE0761) PARM('1')
/*/COPY WNCPYSRC,REH00061                                            */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                        SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0761') +
                          TOMSGQ(MOPERQ)
                        ENDDO
             ENDDO                                                    /*CGL002*/
/**/                                                                  /*CGL002*/
             OVRDBF     FILE(SREFR) TOFILE(NREFR)
             CALL       PGM(RE0761) PARM('2')
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
