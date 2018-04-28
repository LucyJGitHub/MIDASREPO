/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Run EOC from File of Components')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1077  -  RUN END OF CENTRE FROM FILE OF COMPONENTS           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9619            Date 01Feb06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E14166             Date 05Dec88              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   BUG9619 - Close of business components run long if journal      */
/*             cache is enabled                                      */
/*   E14166  -  DUPLICATE DB ERROR WAS BEING WRITTEN TO FILE EOCMGD  */
/*              WHEN ERROR OCCURED IN A CALLED COMPONENT (FROM FILE  */
/*              CMPRND)                                              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MKT)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        &MKT    TYPE(*CHAR)  LEN(2)
             DCL        &ACT    TYPE(*CHAR)  LEN(1)
             DCL        &MSG    TYPE(*CHAR)  LEN(70)
             DCL        &HELD   TYPE(*CHAR)  LEN(1)
/*********** DCL        &MEM1   TYPE(*CHAR)  LEN(44)                   *E14166*/
             DCL        &ESD    TYPE(*CHAR)  LEN(12)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       MKCMPD
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/* OVERRIDE FILE MKCMPD TO THE MEMBER FOR THE END OF CENTRE MARKET  */
/**/
             OVRDBF     MKCMPD MBR(&MKT) SHARE(*NO)
/**/
/* ALLOCATE MARKET DATA AREA                                        */
/**/
RETRY:       ALCOBJ     OBJ((&MKT *DTAARA *SHRRD)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(GOTO RETRY)
/**/
/* SEND JOURNAL ENTRY TYPE 'NC' TO JOURNAL AND                       */
/* CALL FF0472 TO UPDATE END OF CENTRE STATUS INDICATOR TO ACTIVE    */
/**/
             CHGVAR     VAR(&ESD) VALUE('          ' *CAT &MKT)
/**********  SNDJRNE    JRN(ICJRN) TYPE('NC') ENTDTA(&ESD) */                            /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('NC') ENTDTA(&ESD) +
                          FORCE(*YES)                                                    /*BUG9619*/
/**/
             CALL       FF0472 PARM('A' &MKT)
/**/
/* LOOP TO PROCESS EACH COMPONENT IN TURN AS LONG AS EOC IS NOT HELD */
/**/
 NEXT:       RTVDTAARA  DTAARA(&MKT (1 1)) RTNVAR(&HELD)
             IF         COND(&HELD *EQ 'H') THEN(DO)
                 CHGDTAARA  DTAARA(&MKT (1 1)) VALUE(' ')
/**/
/* IF EOC IS TO BE HELD, CALL FF0472                                 */
/**/
                 CALL       FF0472 PARM('H' &MKT)
/**/
/* ALSO CALL FF0473 TO SEND 'HELD' MESSAGE                           */
/**/
                 IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                     CHGVAR     VAR(&ACT) VALUE('I')
                     CHGVAR     VAR(&MSG) VALUE('End of Centre Held')
                     CALL       FF0473 PARM(&MKT &ACT &MSG)
                     DLTOVR     FILE(MKCMPD)
                     GOTO       CMDLBL(ENDPG)
                 ENDDO
             ENDDO
/**/
/* READ A RECORD FROM THE FILE PF/MKCMPD                             */
/**/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO LAST)
/**/
/* WRITE MESSAGE TO FILE                                             */
/**/
             CHGVAR     VAR(&ACT) VALUE(' ')
             CHGVAR     VAR(&MSG) VALUE('Component ' *CAT &LCMP *TCAT +
                          ' in progress')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
/**/
/* CALL COMPONENT WITH MARKET AS PARAMETER                           */
/**/
             CALL       &LCMP PARM(&MKT)
/**/
/* IF A DATABASE ERROR OCCURS, SEND MESSAGE TO MOPERQ                */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM1)          E14166*/
/****************SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM1) +  E14166*/
/*****************************TOMSGQ(MOPERQ)                            E14166*/
/********************************************************************** E14166*/
/**CALL*FF0473*TO*WRITE*A*MESSAGE*TO*THE*END*OF*CENTRE*MESSAGES*FILE*** E14166*/
/********************************************************************** E14166*/
/****************CHGVAR     VAR(&ACT) VALUE('I')                        E14166*/
/****************CHGVAR     VAR(&MSG) VALUE('Database Error -' *BCAT +  E14166*/
/*****************************&LCMP)                                    E14166*/
/****************CALL       FF0473 PARM(&MKT &ACT &MSG)                 E14166*/
                 GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/* IF FILE CONTROLS ARE OUT OF BALANCE, SEND MESSAGES TO MOPERQ     */
/* AND END OF CENTRE MESSAGES FILE                                  */
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                 SNDPGMMSG  MSG('File Controls Out of Balance -' +
                              *BCAT &LCMP) TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('File Controls Out of +
                              Balance -' *BCAT &LCMP)
                 CALL       FF0473 PARM(&MKT &ACT &MSG)
                 GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/* IF PROGRAM TERMINATED ABNORMALLY, SEND MESSAGES TO MOPERQ        */
/* AND END OF CENTRE MESSAGES FILE                                  */
/**/
             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                 SNDPGMMSG  MSG('Component' *BCAT &LCMP *BCAT +
                           'terminated abnormally') TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('Component' *BCAT &LCMP +
                               *BCAT 'terminated abnormally')
                 CALL       FF0473 PARM(&MKT &ACT &MSG)
                 GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/* COMPONENT ENDED NORMALLY: REMOVE COMPONENT FROM COMPONENT FILE , */
/* SEND 'NC' ENTRY TO JOURNAL , SEND MESSAGES AND GO BACK TO TOP    */
/* OF LOOP FOR NEXT COMPONENT                                       */
/**/
             CALL       PGM(FF0474)
             CHGVAR     VAR(&ESD) VALUE('          ' *CAT &MKT)
/**********  SNDJRNE    JRN(ICJRN) TYPE('NC') ENTDTA(&ESD) */                            /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('NC') ENTDTA(&ESD) +
                          FORCE(*YES)                                                    /*BUG9619*/
/**/
             CHGVAR     VAR(&ACT) VALUE(' ')
             CHGVAR     VAR(&MSG) VALUE('Component' *BCAT &LCMP +
                           *BCAT 'completed normally')
             CALL       PGM(FF0473) PARM(&MKT &ACT &MSG)
             GOTO       CMDLBL(NEXT)
/**/
LAST:
/**/
/* SEND MESSAGE AND RESET FLAG FOR COMPLETION OF END OF CENTRE      */
/**/
             CALL       PGM(FF0472) PARM('E' &MKT)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('End of Centre completed +
                              normally')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
             DLTOVR     FILE(MKCMPD)
             GOTO       CMDLBL(ENDPG)
/**/
ABNOR:
             CALL       PGM(FF0472) PARM('F' &MKT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Abnormal Termination - FFC1077') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('End of Centre Terminated +
                            Abnormally')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MKCMPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
ENDPG:
             DLCOBJ     OBJ((&MKT *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
