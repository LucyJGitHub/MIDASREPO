/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI API driver for account postings')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Inovation (TI) Module                         */
/*                                                                   */
/*       TIC0300 - Midas/TI Interface API Driver for A/c Postings    */
/*                                                                   */
/*       Function: This program calls TI0310 in order to update      */
/*                 the TI postings file LF/TIPOSTL0.                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 21May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207601             Date 29Oct02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTI001   *CREATE   Date 16JUL97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard code                           */
/*       207601 - Fail if PSTIN is *NE 'Y' for better error capture. */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&PPROG &PJTTY &PWSID &PUSID &PETKY +
                          &PETNB &PBRNM &PJRDT &PSTIN &PEMSG)
 
/* Program, Transaction subtype, Workstation ID, User ID,           */
/* Transaction Key, Transaction Sequence, Default Branch,           */
/* Transaction Detail, Success flag, Error messages.                */
 
             DCL        VAR(&PPROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PBRNM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PUSID) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PWSID) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PJTTY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PETKY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PETNB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PJRDT) TYPE(*CHAR) LEN(2000)
             DCL        VAR(&PSTIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PEMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PGMNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PETNBNUM) TYPE(*DEC) LEN(7 0)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             IF         COND(&PPROG *EQ 'GZH971') THEN(DO)
             CHGVAR     VAR(&PGMNAM) VALUE('TI0310')
 
             OVRMSGF    MSGF(TIUSRMSG) TOMSGF(GBTIUSRMSG)
             OVRMSGF    MSGF(MIDAS) TOMSGF(GBMIDAS)
 
 /*  Convert binary Trans Sequence into a decimal field  */
             CHGVAR     VAR(&PETNBNUM) VALUE(%BINARY(&PETNB))
 
             CALL       PGM(&PGMNAM) PARM(&PJTTY &PWSID &PUSID +
                          &PETKY &PETNBNUM &PBRNM &PJRDT &PSTIN)
 
/*  Update is unsuccessful */
/**********  IF         COND(&PSTIN *EQ 'N') THEN(DO)              */ /*207601*/
             IF         COND(&PSTIN *NE 'Y') THEN(DO)                 /*207601*/
                                                                      /*207601*/
/*  Handle database error details - fail either way */                /*207601*/
/**********  IF         COND(*%SWITCH(XXXXXX00)) THEN(DO)              BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)        /*BG18886*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             RTVMSG     MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          MSG(&PEMSG)
             GOTO       CMDLBL(ABNOR)                                 /*207601*/
             ENDDO
/**********  ELSE       CMD(RCVMSG PGMQ(*SAME) MSG(&PEMSG))        */ /*207601*/
             ELSE       CMD(DO)                                       /*207601*/
             RCVMSG     PGMQ(*SAME) MSG(&PEMSG)                       /*207601*/
             GOTO       CMDLBL(ABNOR)
             ENDDO                                                    /*207601*/
             ENDDO                                                    /*207601*/
                                                                      /*207601*/
/*  Update is successful - &PSTIN is 'Y' */                           /*207601*/
             ELSE       CMD(DO)                                       /*207601*/
             GOTO       CMDLBL(END)                                   /*207601*/
             ENDDO
 
             ENDDO
             GOTO CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG MSG(&PEMSG)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
