/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Input Cycle Drip-feed Transmission')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0620 - Input Cycle Drip-Feed Transmission                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CMX001  *CREATE    Data 01Jan00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0620INT                                          */
 
             DCL        VAR(&TEMPENTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JSEQN) TYPE(*DEC) LEN(10)
             DCL        VAR(&JSEQA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(MXOLTJPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             ALCOBJ     OBJ((MXOLTJPD *FILE *EXCLRD)) WAIT(30)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             SNDPGMMSG  MSG('Attempt to start Midas Export Drip-Feed +
                          Transmission has failed. Probable cause: +
                          process is active already.') +
                          TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB SWS(00000000)
 
             ADDLIBLE   LIB(QMQM) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,MXC0620MPS                                          */
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(MXOLTJPD) SHARE(*NO)
 
             RCVF
 
             OVRDBF     FILE(MXMQDLL1) MBR(IDRIP) SHARE(*NO)
 
 
             CHGVAR     VAR(&JSEQN) VALUE(&I#LASTSEQ)
 
/* Check if journal sequence exists. */
/* If journal sequence does not exist, set to restart at first entry */
 
             RTVJRNE    JRN(ICJRN) FROMENT(&JSEQN) TOENT(&JSEQN) +
                          RTNENTTYP(&TEMPENTYP)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CHGVAR     VAR(&JSEQN) VALUE(0)
                   RTVJRNE    JRN(ICJRN) FROMENT(*FIRST) +
                                TOENT(*FIRST) RTNSEQNBR(&JSEQN)
                   MONMSG     MSGID(CPF0000)
                ENDDO
 
             CHGVAR     VAR(&JSEQN) VALUE(&JSEQN + 1)
 
/* Receive journal entries*/
 
             RCVJRNE    JRN(ICJRN) EXITPGM(MXDRIPTRM) +
                          FILE((MXTRIGPD)) RCVRNG(*CURCHAIN) +
                          FROMENT(&JSEQN) JRNCDE((R) (U)) ENTTYP(PT +
                          XJ XE) ENTFMT(*TYPE1) DELAY(*NEXTENT)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               ROLLBACK
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0620 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MXC0620MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0620ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0620 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0620END                                          */
 
             DLCOBJ     OBJ((MXOLTJPD *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
