/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Reset Failed Machine')                          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*      SDC1759 - RESET FAILED MACHINE                              */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01345             Date 06Nov91              */
/*                      S01179             Date 13/09/88             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*      S01345 - JOURNALLING SYSTEM RE-WRITE.                       */
/*      S01179 - AS400 CONVERSION                                   */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   Initial processing                                             */
/**/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
/**********  DCLDTAARA  DTAARA(MPHAS)                               *  *S01179*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                /*S01179*/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
/**/
/*   Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Reset Failed Machine') +
                          TOMSGQ(MRUNQ)
/**/
/*   Reset primary/backup flag in JNSTAT                             */
/**/
             RTVDTAARA  DTAARA(JNSTAT *ALL) RTNVAR(&JNSTAT)
             CHGVAR     VAR(%SST(&JNSTAT 82 1)) VALUE('B')
/**********  SNDDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             CHGDTAARA  DTAARA(JNSTAT) VALUE(&JNSTAT)                 /*S01179*/
/**/
/*   Reset phase to input cycle                                      */
/**/
/**********  RCVDTAARA  DTAARA(MPHAS)                               *  *S01179*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                  /*S01179*/
             CHGVAR     VAR(&MPHAS) VALUE('A')
/**********  SNDDTAARA  DTAARA(MPHAS)                               *  *S01179*/
             CHGDTAARA  DTAARA(MPHAS) VALUE(&MPHAS)                   /*S01179*/
/**/
/*   End journalling if necessary                                    */
/**/
             ENDJRNPF   FILE(*ALL) JRN(ICJRN)
/**/
/****Call*SDC1730*to*start*journalling*all*files***/                  /*S01345*/
/**/
/************CALL       PGM(SDC1730) **/                              /*S01345*/
/**/                                                                  /*S01345*/
/*   Call SCJRN to start journalling all files  */                    /*S01345*/
/**/                                                                  /*S01345*/
             CALL       PGM(SCJRN)                                    /*S01345*/
             IF         COND(%SWITCH(XXXXXX0X)) THEN(GOTO END)
/**/
/*   Abnormal termination processing                                 */
/**/
 ABNOR:      SNDPGMMSG  MSG('Reset Failed Machine ENDED +
                        ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
