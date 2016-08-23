/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF EOC Monitor Proc. Control')                  */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1076  -  END OF CENTRE MONITOR PROCESSING CONTROL PGM        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. 00                 DATE 00/00/00                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CHANGE DESCRIPTIONS                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                  */
/*   DECLARE VARIABLES                                              */
/*                                                                  */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                  */
/* ALLOCATE DATAAREA FFECA                                          */
/*                                                                  */
             ALCOBJ     OBJ((FFECA *DTAARA *EXCL)) WAIT(0)
/*                                                                  */
/* Monitor message                                                  */
/*                                                                  */
             MONMSG  MSGID(CPF1002) EXEC(GOTO INUSE)
/*                                                                  */
/* Call END OF CENTRE MONITOR PROGRAM FF0471                        */
/*                                                                  */
             CALL       PGM(FF0471)
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ                                                */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)  TOMSGQ(MOPERQ)
             ENDDO
/*                                                                  */
/* DEALLOCATE DATAAREA FFECA                                        */
/*                                                                  */
             DLCOBJ     OBJ((FFECA *DTAARA *EXCL))
             GOTO END
/*                                                                  */
/* If FF0471 is in use send message                                 */
/*                                                                  */
 INUSE:
             SNDPGMMSG  MSG('END OF CENTRE MONITOR ACTIVE AT +
                        ANOTHER WORKSTATION') TOPGMQ(*EXT)
/*                                                                  */
             GOTO END
/*                                                                  */
/*     Abnormal error processing. Message to MOPERQ MRUNQ & WORKSTN */
/*                                                                  */
 ABNOR:      SNDPGMMSG  MSG('FFC1076 - END OF CENTRE MONITOR +
                        ENDED ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*                                                                  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                  */
/* DEALLOCATE DATAAREA FFECA                                        */
/*                                                                  */
             DLCOBJ     OBJ((FFECA *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXXX1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                  */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
/*                                                                  */
