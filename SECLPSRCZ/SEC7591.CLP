/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE CO Generate Forward Events Cust/Depot')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7591 - SE CO Gen Forward Events Cust/Depot Allocation    */
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
/*       Prev Amend No. CSE007  *CREATE    Date 23Mar98              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
 
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
/* Get system ID to build DLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')
 
/* Send Information Program Message */
             SNDPGMMSG  MSG('SEC7591 - Generation of forward events +
                          Cust/Depot') TOMSGQ(MRUNQ)
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Override to SEQONLY(*YES 100) */
             OVRDBF     FILE(CPEVED)  SEQONLY(*YES 100)
             OVRDBF     FILE(CPEVEA)  SEQONLY(*YES 100)
             OVRDBF     FILE(DPEVED)  SEQONLY(*YES 100)
             OVRDBF     FILE(DPEVEA)  SEQONLY(*YES 100)
 
             OVRDBF     FILE(XCPEVED)  SEQONLY(*YES 100)
             OVRDBF     FILE(XCPEVEA)  SEQONLY(*YES 100)
             OVRDBF     FILE(XDPEVED)  SEQONLY(*YES 100)
             OVRDBF     FILE(XDPEVEA)  SEQONLY(*YES 100)
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If it's a Restart, Restore Security Copies */
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DLIB/XCPEVED) TOFILE(CPEVED) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CPEVED)
 
             CPYF       FROMFILE(&DLIB/XCPEVEA) TOFILE(CPEVEA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CPEVEA)
 
             CPYF       FROMFILE(&DLIB/XDPEVED) TOFILE(DPEVED) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DPEVED)
 
             CPYF       FROMFILE(&DLIB/XDPEVEA) TOFILE(DPEVEA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DPEVEA)
 
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
             DLTF       FILE(&DLIB/XCPEVED)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XCPEVEA)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XDPEVED)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XDPEVEA)
             MONMSG MSGID(CPF0000)
 
             CPYF FROMFILE(CPEVED) TOFILE(&DLIB/XCPEVED) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DLIB/XCPEVED))
 
             CPYF FROMFILE(CPEVEA) TOFILE(&DLIB/XCPEVEA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DLIB/XCPEVEA))
 
             CPYF FROMFILE(DPEVED) TOFILE(&DLIB/XDPEVED) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DLIB/XDPEVED))
 
             CPYF FROMFILE(DPEVEA) TOFILE(&DLIB/XDPEVEA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DLIB/XDPEVEA))
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             ENDDO
 
/* Delete overrides */
             DLTOVR     FILE(CPEVED CPEVEA DPEVED DPEVEA XCPEVED +
                          XCPEVEA XDPEVED XDPEVEA)
 
/* Call RPG name */
             CALL       PGM(SE7591)
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               SNDMSG     MSG('SE7591 ended abnormally for job ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               SNDMSG     MSG('SE7591 ended abnormally for job ' *CAT  +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* If the job is completed normally */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/* Delete Security Copies */
             DLTF       FILE(&DLIB/XCPEVED)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XCPEVEA)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XDPEVED)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XDPEVEA)
             MONMSG MSGID(CPF0000)
 
ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
