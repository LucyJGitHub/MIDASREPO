/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Create multi-language format options')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC7990  - Create Multi-Language Format Options             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 096647             DATE 30NOV95              */
/*       PREV AMEND NO. CCG009             DATE 01JUN95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       096647 - Add new parameters                                 */
/*       CCG009 - Private Banking UDC   (NEW PROGRAM)                */
/*                                                                   */
/*********************************************************************/
 
/************PGM        PARM(&LANG)                                    *096647*/
             PGM        PARM(&FORMAT_OPT &LANG &OVER_WRITE)           /*096647*/
 
/* Copyright Statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Parameters                                                        */
             DCL        VAR(&LANG)        TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTN_CDE)     TYPE(*CHAR) LEN(10)         /*096647*/
             DCL        VAR(&FORMAT_OPT)  TYPE(*CHAR) LEN(10)         /*096647*/
             DCL        VAR(&OVER_WRITE)  TYPE(*CHAR) LEN(1)          /*096647*/
             DCL        VAR(&DATA)        TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('CGC7990 - Create Multi-language Format +
                          Options') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(00000000)
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(GBCGUSRMSG)
             OVRMSGF    MSGF(MIDAS   ) TOMSGF(GBMIDAS   )
 
/* Call the Multi-Language Format Option Creation Program            */
 
/************CALL       PGM(CG7990) PARM(&LANG)                        *096647*/
             CALL       PGM(CG7990) PARM(&RTN_CDE &FORMAT_OPT &LANG +
                          &OVER_WRITE)                                /*096647*/
 
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNORMAL)
                ENDDO
 
/* */
/* Check for invalid language */
/* */
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
             SNDPGMMSG  MSG('Invalid language. No multi-language +
                          format options created.') TOPGMQ(*EXT)
             ENDDO
 
/* Terminate Program normally                                        */
 
             GOTO       CMDLBL(ENDCLPGM)
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             DMPCLPGM
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC7990 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC7990 ended abnormally') MSGTYPE(*ESCAPE)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
