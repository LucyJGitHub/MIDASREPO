/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Create SPF environment for auto gen')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                       */
/*                                                                   */
/*       MEC1310  - Create SPF environment for Auto Gen              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD050514           Date 18Apr18              */
/*       Prev Amend No. MD043618           Date 07Dec17              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CAP084             Date 08Jul03              */
/*                      CSF002             Date 11Aug03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      197434             Date 09Oct01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01435             Date 21Sep93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD050514 - ME_FT_IMM job in MSGW                            */
/*       MD043618 - Job ME_FT_IMM when started manually it is        */
/*                  submitted  with user’s profile and not system    */
/*                  owner profile -Formalization of onsite fix.      */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP084 - Parameter added to ZMUSER for Java wrappers        */
/*       CSF002 - Global layer.                                      */
/*                - Replace previous key data with the new unique    */
/*                  code.                                            */
/*       197434 - Array index error on SF0021. Increase maximum      */
/*                number of branches from 100 to 900.                */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&ERRCDE) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CAP084*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                                  /*MD050514*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1310 - Create SPF enviroment for +
                          Auto Gen') TOMSGQ(MRUNQ)
/* */
/* Create data areas */
/* */
             CRTDTAARA  DTAARA(QTEMP/ZBRU) TYPE(*CHAR) LEN(304) +
                          TEXT('User valid Booking Branches')
                                                                                          /*197434*/
/** Create more data area to contain the valid booking branches  */                       /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZBRU1) TYPE(*CHAR) LEN(1998) +
                          TEXT('User valid Booking Branches 1')                           /*197434*/
             MONMSG     MSGID(CPF0000)                                                    /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZBRU2) TYPE(*CHAR) LEN(402) +
                          TEXT('User valid Booking Branches 2')                           /*197434*/
             MONMSG     MSGID(CPF0000)                                                    /*197434*/
/* */
             CRTDTAARA  DTAARA(QTEMP/ZOBU) TYPE(*CHAR) LEN(304) +
                          TEXT('User valid Originating Branches')
                                                                                          /*197434*/
/** Create more data area to contain the valid originating branches*/                     /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZOBU1) TYPE(*CHAR) LEN(1998) +
                          TEXT('User valid Originating Branches 1')                       /*197434*/
             MONMSG     MSGID(CPF0000)                                                    /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZOBU2) TYPE(*CHAR) LEN(402) +
                          TEXT('User valid Originating Branches 2')                       /*197434*/
             MONMSG     MSGID(CPF0000)                                                    /*197434*/
/* */
             CRTDTAARA  DTAARA(QTEMP/ZCMP) TYPE(*CHAR) LEN(304) +
                          TEXT('User valid Companies')
/* */
/* Create ZMUSER data area  */
/* */
/************CALL       PGM(ZMUSER) PARM(&ERRCDE)                                         /*CAP084*/
/**********  CALL       PGM(ZMUSER) PARM(&ERRCDE &ZMUSER)                        /*CAP084 MD043618*/
/**********  IF         COND(&ERRCDE *EQ 1) THEN(GOTO CMDLBL(ABNORMAL))                 /*MD043618*/
                                                                                        /*MD050514*/
/** Create data area and update with the job user profile */                            /*MD050514*/
                                                                                        /*MD050514*/
             CRTDTAARA DTAARA(QTEMP/ZMUSER) TYPE(*CHAR) LEN(17)                         /*MD050514*/
             RTVJOBA    USER(&USER)                                                     /*MD050514*/
             CHGDTAARA  DTAARA(QTEMP/ZMUSER (1 10)) VALUE(&USER)                        /*MD050514*/
/* */
/* Set up other data ares   */
/* */
             CALL       PGM(SF0400)
/* */
/* Set up ZMITEM data ares  */
/* */
/**********  CRTDTAARA  DTAARA(QTEMP/ZMITEM) TYPE(*CHAR) LEN(9) +    */                   /*CSF002*/
/**********               VALUE('D0380FTAG') TEXT('Menu Group/Item + */                   /*CSF002*/
/**********               Code')                                     */                   /*CSF002*/
             CRTDTAARA  DTAARA(QTEMP/ZMITEM) TYPE(*CHAR) LEN(10) +
                          VALUE('0000001632') TEXT('Midas SF Menu +
                          group/item code')                                               /*CSF002*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1310 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1310 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
