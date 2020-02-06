/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Test for existence of SCAUTOBKP')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/* RRCHKAUTO - CHECK WHETHER RRAUTOBKP JOB IS ACTIVE IN THE SYSTEM  */
/*             THIS PROGRAM HAS BEEN WRITTEN FOR ERROR E81140       */
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
/*       Prev Amend No. E24680             Date 18Sep91              */
/*                      S01343             Date 15Aug91              */
/*                    E10752             DATE 02/06/87              */
/*                    E81140             DATE 19/08/86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     E24680 - THE PGM USES DSPJOB TO DETERMINE WHETHER RRAUTOBKP  */
/*              IS ACTIVE. USING THIS METHOD DOES HOWEVER RESULT    */
/*              IN RRCHKAUTO THINKING THAT RRAUTOBKP IS ACTIVE IF A */
/*              COMPLETED JOB IS FOUND. IT WOULD BE BETTER TO USE   */
/*              DSPJOBLOG AS THIS ONLY WORKS FOR ACTIVE JOBS.       */
/*     S01343 - SC/RR/SD MODULE RENAME PROJECT.                     */
/*              - RENAMED FROM CHKAUTO                              */
/*              - AUTOBKP RENAMED TO RRAUTOBKP.                     */
/*     E10752 - QDSPJOB IS USED INSTEAD OF QPDSPJOB.  WHEN THE      *  *E10752*/
/*              THE JOB IS DISPLAYED IT IS NOT DISPLAYED TO *LIST.  *  *E10752*/
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
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
/**/
             CHGVAR     VAR(&JOBN) VALUE(%SST(&JNSTAT 111 10))
             CHGVAR     VAR(&USRN) VALUE(%SST(&JNSTAT 121 10))
             CHGVAR     VAR(&JBNB) VALUE(%SST(&JNSTAT 131 6))
/**/
/*   OVERRIDE PRINTER FILE SO THAT ANY PRINTS PRODUCED ARE HELD   */
/**/
/**/                                                                  /*E10752*/
/*           OVRPRTF    FILE(QDSPJOB) HOLD(*YES)     */
/************OVRPRTF    FILE(QPDSPJOB) HOLD(*YES) ***/                /*E24680*/
             OVRPRTF    FILE(QPJOBLOG) HOLD(*YES)                     /*E24680*/
/**/                                                                  /*E10752*/
/**/
/*   DISPLAY JOB IF IT EXISTS - IF NOT THEN MONITOR MESSAGE TAKES   */
/*   CARE OF INDICATOR IN DATA AREA JNSTAT   */
/**/
/**/                                                                  /*E10752*/
/*           DSPJOB     JOB(&JOBN.&USRN.&JBNB)    */
/************DSPJOB     JOB(&JBNB/&USRN/&JOBN) OUTPUT(*PRINT) **/     /*E24680*/
             DSPJOBLOG  JOB(&JBNB/&USRN/&JOBN) OUTPUT(*PRINT)         /*E24680*/
/**/                                                                  /*E10752*/
/************MONMSG     MSGID(CPF1070) EXEC(DO) ***/                  /*E24680*/
             MONMSG     MSGID(CPF1070 CPF2443 CPF2523) EXEC(DO)       /*E24680*/
                CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE('N')
             ENDDO
/**/
/*   CANCEL SPOOL FILE IF ANY CREATED AND DELETE OVERRIDE   */
/**/
/**/                                                                  /*E10752*/
/*           CNLSPLF    FILE(QDSPJOB) SPLNBR(*LAST)     */
/************DLTSPLF    FILE(QPDSPJOB) SPLNBR(*LAST) ***/             /*E24680*/
             DLTSPLF    FILE(QPJOBLOG) SPLNBR(*LAST)                  /*E24680*/
/**/                                                                  /*E10752*/
             MONMSG     MSGID(CPF3303)
/**/                                                                  /*E10752*/
/*           DLTOVR     FILE(QDSPJOB)  */
/************DLTOVR     FILE(QPDSPJOB) ***/                           /*E24680*/
             DLTOVR     FILE(QPJOBLOG)                                /*E24680*/
/**/                                                                  /*E10752*/
             RETURN
/**/
/*   ABNORMAL TERMINATION OF PROGRAM   */
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM RRCHKAUTO ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ  MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
