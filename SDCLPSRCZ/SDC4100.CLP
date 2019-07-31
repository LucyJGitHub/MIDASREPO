/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD BTS COB control component')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                            */
/*                                                                   */
/*       Business Transaction Statistics Switchable Feature          */
/*                                                                   */
/*       SDC4100  - BTS COB control component                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      134498             Date 12Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      068922             DATE 02APR94              */
/*                      S01411             DATE 08APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       134498 - Clear BTS file before running component, whether   */
/*                this is a restart or not, else may get duplicate   */
/*                record if COB was reopened.                        */
/*       068922 - REPLACE SDBTDLPD WITH SDBTFRPD                     */
/*       S01411 - New program for BTS                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &PGM)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,SDC4100001                                          */
/* */
/* Global monitor */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* */
/* Change the switches U7 & U8 off */
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
/* &PGM should not be blank */
/* */
             IF         COND(&PGM *EQ ' ') THEN(DO)
                SNDPGMMSG  MSG('Program SDC4100 called with a blank +
                             parameter') TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/* */
/* Check to see if this is a restart */
/* */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/* */
/* If this is not a restart then seton the restart flag */
/* */
             IF         COND(&STAT *EQ 'N') THEN(DO)
                CHGVAR     VAR(&STAT) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/* */
/**If*this*is*a*restart*then*run*the*restart*processing**/            /*134498*/
/************                                                      */ /*134498*/
/************ELSE       CMD(DO)                                    */ /*134498*/
 
                IF         COND(&PGM *EQ 'SD4101') THEN(CLRPFM +
                             FILE(SDBTGLPD))
 
                IF         COND(&PGM *EQ 'SD4102') THEN(CLRPFM +
                             FILE(SDBTLEPD))
 
                IF         COND(&PGM *EQ 'SD4103') THEN(CLRPFM +
                             FILE(SDBTFXPD))
 
                IF         COND(&PGM *EQ 'SD4104') THEN(CLRPFM +
                             FILE(SDBTMMPD))
 
                IF         COND(&PGM *EQ 'SD4105') THEN(CLRPFM +
                             FILE(SDBTNPPD))
 
                IF         COND(&PGM *EQ 'SD4106') THEN(CLRPFM +
                             FILE(SDBTNSPD))
 
                IF         COND(&PGM *EQ 'SD4107') THEN(CLRPFM +
                             FILE(SDBTFRPD))
/**********                  FILE(SDBTDLPD))                            068922*/
 
                IF         COND(&PGM *EQ 'SD4108') THEN(CLRPFM +
                             FILE(SDBTFFPD))
 
                IF         COND(&PGM *EQ 'SD4109') THEN(CLRPFM +
                             FILE(SDBTSEPD))
 
                IF         COND(&PGM *EQ 'SD4110') THEN(CLRPFM +
                             FILE(SDBTDMPD))
 
                IF         COND(&PGM *EQ 'SD4111') THEN(CLRPFM +
                             FILE(SDBTF1PD))
 
                IF         COND(&PGM *EQ 'SD4112') THEN(CLRPFM +
                             FILE(SDBTF2PD))
 
                IF         COND(&PGM *EQ 'SD4113') THEN(CLRPFM +
                             FILE(SDBTF3PD))
 
                IF         COND(&PGM *EQ 'SD4114') THEN(CLRPFM +
                             FILE(SDBTF4PD))
 
                IF         COND(&PGM *EQ 'SD4115') THEN(CLRPFM +
                             FILE(SDBTF5PD))
 
                IF         COND(&PGM *EQ 'SD4116') THEN(CLRPFM +
                             FILE(SDBTF6PD))
 
                IF         COND(&PGM *EQ 'SD4117') THEN(CLRPFM +
                             FILE(SDBTF7PD))
/*/COPY WNCPYSRC,SDC4100002                                          */
 
/************ENDDO                                                 */ /*134498*/
/* */
/* Processing for ACCNTAB */
/* */
             IF         COND(&PGM *EQ 'SD4101') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS accounts processing') +
                           TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4101)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for CLOANCL */
/* */
             IF         COND(&PGM *EQ 'SD4102') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS lending processing') +
                           TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4102)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for DEALSDB */
/* */
             IF         COND(&PGM *EQ 'SD4103') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS foreign exchange +
                           processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4103)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for DEALSDC */
/* */
             IF         COND(&PGM *EQ 'SD4104') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS money market +
                           processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4104)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for DEALSDD */
/* */
             IF         COND(&PGM *EQ 'SD4105') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS negotiable assets +
                           purchased processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4105)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for DEALSDE */
/* */
             IF         COND(&PGM *EQ 'SD4106') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS negotiable assets +
                           sold processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4106)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for DEALSDG */
/* */
             IF         COND(&PGM *EQ 'SD4107') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS FRA/IRS processing') +
                           TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4107)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for TRANSD */
/* */
             IF         COND(&PGM *EQ 'SD4108') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS futures and options +
                           processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4108)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for TRADSD */
/* */
             IF         COND(&PGM *EQ 'SD4109') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS trades processing') +
                           TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4109)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for DPTMVD */
/* */
             IF         COND(&PGM *EQ 'SD4110') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS depot movements +
                           processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4110)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for CQPACDD */
/* */
             IF         COND(&PGM *EQ 'SD4111') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS cheques to be paid - +
                           credit') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4111)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for CQPADDD */
/* */
             IF         COND(&PGM *EQ 'SD4112') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS cheques to be paid - +
                           debit') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4112)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for CQCDCDD */
/* */
             IF         COND(&PGM *EQ 'SD4113') THEN(DO)
             SNDPGMMSG  MSG('SDC4100 - BTS cheques for collection - +
                          credit') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4113)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for CQCODDD */
/* */
             IF         COND(&PGM *EQ 'SD4114') THEN(DO)
             SNDPGMMSG  MSG('SDC4100 - BTS cheques for collection - +
                          debit') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4114)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for INPAYDD */
/* */
             IF         COND(&PGM *EQ 'SD4115') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS incoming payments +
                           processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4115)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for OTPAYDD */
/* */
             IF         COND(&PGM *EQ 'SD4116') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS outgoing payments +
                           processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4116)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Processing for NTRANDD */
/* */
             IF         COND(&PGM *EQ 'SD4117') THEN(DO)
                SNDPGMMSG  MSG('SDC4100 - BTS nostro transfers +
                           processing') TOMSGQ(MRUNQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CALL       PGM(SD4117)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* */
/* Send error message if an invalid parameter was passed */
/* */
             SNDPGMMSG  MSG('Program SDC4100 called with an invalid +
                          parameter') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
/* */
/* Check for failure in called program */
/* */
 CHECK:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Program ' *CAT &PGM *BCAT +
                             'ended in error')
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/*/COPY WNCPYSRC,SDC4100003                                          */
/* */
/* Reset failed component flag to 'N' on successful completion */
/* */
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             GOTO       CMDLBL(END)
 
/* */
/** Abnormal error processing */
/* */
 ABNOR:      SNDPGMMSG  MSG('Program SDC4100 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
