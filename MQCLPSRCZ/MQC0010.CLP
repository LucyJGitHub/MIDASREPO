/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ Midas/Q selection from Midas menu')          */
/********************************************************************/
/*                                                                  */
/*    Midas SETUPMIDAS ENHANCEMENTS                                 */
/*                                                                  */
/*    MQC0010    -  PROGRAM FOR MIDAS/Q SELECTION FROM MIDAS MENU.  */
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
/*       Prev Amend No. 120265             Date 31Oct97              */
/*                      050295             Date 27Apr94              */
/*                   E23515           DATE 12SEP90                  */
/*                   E22749           DATE 25JUL90                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*    120265 - Override SDCURRL1 to SHARE(*NO) to allow reports to  */
/*             run interactively.                                   */
/*    050295 - MIDAS/Q MENU OPTION NOT AVAILABLE AFTER ERROR        */
/*           - REMOVE MIDAS/Q LIBRARY AFTER ABNORMAL END TO JOB     */
/*    E23515 - DOES NOT NEED TO BE AN ADOPTION PGM. IT IS           */
/*             SUFFICIENT FOR ITS AUTHORITY TO BE LIMITED TO MIDAS  */
/*             USERS, I.E. TO HAVE AUTHORITY *PUBLIC *EXCLUDE.      */
/*    E22749 - Program Written to fix Error Re: Hard coding         */
/*             of Midas/Q Command in Midas Menus.                   */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBX) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(75)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   Global monitor message   */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/
/*  Set initial values  */
/**/
BEGPGM:      CHGVAR     VAR(&LIB) VALUE('M#QLIBDTA')
 
/**/
/*  Retrieve the data area  */
/**/
             RTVDTAARA  DTAARA(MQLIBS (1 10)) RTNVAR(&LIBX)
             MONMSG     MSGID(CPF0000)
/**/
/*  Check data area is not blank  */
/**/
             IF         COND(&LIBX *NE ' ') THEN(DO)
             CHGVAR     VAR(&LIB) VALUE(&LIBX)
             ENDDO
/**/
/*  Add <dtalib> to library list */
/**/
             ADDLIBLE   LIB(&LIB)
/**/                                                                /* 120265 */
/*  Override SDCURRL1 to SHARE(*NO)  */                             /* 120265 */
/**/                                                                /* 120265 */
             OVRDBF     FILE(SDCURRL1) SHARE(*NO)                   /* 120265 */
/**/
/*  Execute Midas/Q Command */
/**/
             MIDASQ
/**/
/*  Remove <dtalib> from library list */
/**/
             RMVLIBLE   LIB(&LIB)
             MONMSG     MSGID(CPF0000)
/**/
/*   Normal End to job   */
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/*   Abnormal End to job   */
/**/
ABNOR:       CHGVAR     VAR(&MEM) VALUE('MQC0010 - Error has occurred +
                          on call - See low level messages')
             SNDPGMMSG  MSG(&MEM)
/**/                                                                  /*050295*/
/*  Remove <dtalib> from library list */                              /*050295*/
/**/                                                                  /*050295*/
             RMVLIBLE   LIB(&LIB)                                     /*050295*/
             MONMSG     MSGID(CPF0000)                                /*050295*/
/**/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
