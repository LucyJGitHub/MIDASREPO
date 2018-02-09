/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE CI Forward Report')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - RE Module                                           */
/*                                                                   */
/*       REC4300 - CI Forward Report                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CRT008  *CREATE    Date 18Oct02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CRT008 - Forward Report Enhancements                        */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)             */                     /*CCB020*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
/**/
/**RETRIEVE*MPHAS**/                                                                      /*CCB020*/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)               */                     /*CCB020*/
 
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('CI FORWARDING EXCEPTIONS REPORT') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             CHGJOB SWS(00000000)
 
/**/
/*  Call the program to print the report  */
/**/
/**********  CALL       PGM(RE4300) PARM(&RSEQ &RLEV &RENT &MPHAS) */                     /*CCB020*/
             CALL       PGM(RE4300) PARM(&RSEQ &RLEV &RENT)                               /*CCB020*/
 
                        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                        GOTO       CMDLBL(END)
                        ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4300 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                        REC4202 ended abnormally - see job log') +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
