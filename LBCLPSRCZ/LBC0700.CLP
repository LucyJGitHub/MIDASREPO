/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Portfolio Lending Extrct Summary Creatn')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0700 - Portfolio Lending Extract Summary Creation        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01498             Date 11Aug94              */
/*                      S01189             Date 11Aug92              */
/*                      S01355             DATE 10JUL92              */
/*                      35723              DATE 20MAR92              */
/*                      R0720              DATE 14NOV90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       S01355 - RELEASE 3 INCORPORATION                            */
/*       35723  - LB PROGRAM CANNOT BE RESTARTABLE                   */
/*       R0720  - FILE LBEXTSPD ALREADY IN USE                       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
 
/*>>S01189>>*/
/**********  PGM                                                    **/
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* RESET JOB SWITCHES                                                */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
/* >>>>> S01355 >>>>> */
/*           SNDPGMMSG  MSG('LBC0700 - Lombard Summary Creation') +       */
/*                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)                    */
             SNDPGMMSG  MSG('LBC0700 - portfolio lending Summary +
                          Creation') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/* <<<<< S01355 <<<<< */
 
/* CLEAR LOMBARD SUMMERY FILE                                        */
             CLRPFM     FILE(*LIBL/LBEXTSPD)
/*           MONMSG     MSGID(CPF0000)                              */ /*R0720*/
 
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE(' ')
                   CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/* EXECUTE PROGRAM                                                   */
             CALL       PGM(*LIBL/LB0700)
 
/* ERROR DURING PROCESSING                                           */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
/*>>35723>>*/
             CHGJOB     SWS(XXXXXX11)
/*<<35723<<*/
             SNDPGMMSG  MSG('LBC0700 - Ended abnormally') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0700 - Ended abnormally') +
                          TOMSGQ(MOPERQ)
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* DATABASE IN ERROR DURING PROCESSING                               */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             SNDPGMMSG  MSG('LBC0700 - Database error') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0700 - Database error') TOMSGQ(MOPERQ)
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE DURING PROCESSING                    */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('LBC0700 - File Controls out of Balance') +
                          TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0700 - File Controls out of Balance') +
                          TOMSGQ(MOPERQ)
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
 
/*END:********ENDPGM                                               */ /*S01498*/
 ENDPGM:                                                              /*S01498*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01498*/
