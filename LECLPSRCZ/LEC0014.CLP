/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Initialisation pgm for CPAM and INTR flds')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0014 - Initialisation Program for CPAM and INTR Fields.  */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 208836 *CREATE     Date 17Sep02              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       208836 - Fields CPAM and INTR in HISTSHM are not            */
/*                initialised when switchable feature CLE003 is      */
/*                switched on                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCD &MODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
             DCL        VAR(&RETCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256))
 
/* Mode 1 (First call) */
 
             IF         COND(&MODE *EQ '1') THEN(DO)
                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
                MONMSG     MSGID(CPF8351)
                CALL       PGM(LE0014)
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
             ENDDO
 
/* Mode 2 (Second call) */
 
             IF         COND(&MODE *EQ '2') THEN(DO)
                SNDPGMMSG  MSG('Program LEC0014 has already been run +
                             and should not be re-run') TOPGMQ(*EXT)
             ENDDO
 
/** Mode 3 - Deletion */
 
             IF         COND(&MODE *EQ '3') THEN(DO)
                SNDPGMMSG  MSG('Feature CLE003 cannot be switched off') +
                          TOPGMQ(*EXT)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal termination */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSG('Program LEC0014 ended abnormally') +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&RETCD) VALUE('*ERROR*')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC0014 ended abnormally - see joblog +
                          ') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/** End program */
 
 END:
             ENDPGM
