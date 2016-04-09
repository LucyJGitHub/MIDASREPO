/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas HF Terminate HAFMONITOR')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - HAF Module                                          */
/*                                                                   */
/*       HFC0252 - Terminate HAFMONITOR                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR884055           Date 11Jan12              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      167607             Date 17Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB001 *CREATE     DATE 01MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR884055 - HAF wait time can exceed 999 seconds.            */
/*                  (Child: AR884056)                                */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       167607 - After flagging HAFMONITOR to end, ensure that it   */
/*                has ended before allowing COB to continue, else    */
/*                will cause database backup/end journalling failure.*/
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
/***COPY*HFCPYSRC,HFC0252INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,HFC0252INT                                          */                   /*CPK024*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&ETWAIT4) TYPE(*DEC) LEN(4 0)                               /*AR884055*/
 
             DCLF SDHAFDPD                                            /*167607*/
                                                                      /*167607*/
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*HFCPYSRC,HFC0252MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,HFC0252MPS                                          */                   /*CPK024*/
 
/**/
/* Stop the HAF monitor from running                               */
/**/
 
             CHGDTAARA  DTAARA(HFCOB) VALUE(STOP)
 
/* Attempt to allocate HFLOCK - use the HAF Wait Time + 30 secs. */   /*167607*/
/* If unable to allocate, then HAFMONITOR is still active.       */   /*167607*/
                                                                      /*167607*/
             RCVF                                                     /*167607*/
                                                                                        /*AR884055*/
/* Use a 4-digit variable in case calculated wait time is greater */                    /*AR884055*/
/* than 999 seconds. */                                                                 /*AR884055*/
                                                                                        /*AR884055*/
/**********  CHGVAR     VAR(&ETWAIT) VALUE(&ETWAIT + 30)                         /*167607 AR884055*/
             CHGVAR     VAR(&ETWAIT4) VALUE(&ETWAIT + 30)                               /*AR884055*/
/**********  ALCOBJ     OBJ((HFLOCK *DTAARA *EXCL)) WAIT(&ETWAIT)                /*167607 AR884055*/
             ALCOBJ     OBJ((HFLOCK *DTAARA *EXCL)) WAIT(&ETWAIT4)                      /*AR884055*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*167607*/
             SNDPGMMSG  MSG('HFC0252 - Unable to end HAFMONITOR') +
                          TOMSGQ(MOPERQ)                              /*167607*/
             ENDDO                                                    /*167607*/
                                                                      /*167607*/
/***COPY*HFCPYSRC,HFC0252MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,HFC0252MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*HFCPYSRC,HFC0252ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,HFC0252ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSG('Program HFC0252 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
/***COPY*HFCPYSRC,HFC0252END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,HFC0252END                                          */                   /*CPK024*/
 
             DLCOBJ     OBJ((HFLOCK *DTAARA *EXCL))                   /*167607*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*167607*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
