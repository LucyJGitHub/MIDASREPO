/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Retrieve OS/400 level')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       UTC0280 - Retrieve operating system level                   */
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
/*       Prev Amend No. 102445 *CREATE     Date 21AUG96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       102445 - Retrieve operating system level                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&IBMLVL &RPYTYP)
 
/*/COPY WNCPYSRC,UTC0280INT                                          */
 
             DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RPYTYP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RCVVAR) TYPE(*CHAR) LEN(25)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('PRDR0100')
             DCL        VAR(&PRDINF) TYPE(*CHAR) LEN(27) +
                          VALUE('*OPSYS *CUR  0000*CODE    ')
             DCL        VAR(&V2R3) TYPE(*CHAR) LEN(1) VALUE('Y')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,UTC0280MPS                                          */
 
         CALL       PGM(QSZRTVPR) PARM(&RCVVAR X'00000019' +
                      &FORMAT &PRDINF X'00000000')
 
/*    If API not found system is pre-V2R3                          */
 
         MONMSG     MSGID(CPF0000) EXEC(DO)
            CHGVAR     VAR(&V2R3) VALUE('N')
            RTVDTAARA  DTAARA(QSYS/QSS1MRI (1 6)) RTNVAR(&IBMLVL)
         ENDDO
 
         IF         COND(&V2R3 = 'Y') THEN(DO)
            CHGVAR     VAR(&IBMLVL) VALUE(%SST(&RCVVAR 20 6))
         ENDDO
 
         IF         COND(&RPYTYP = '*MSG') THEN(DO)
             SNDPGMMSG  MSG('Operating system level is ' *CAT +
                          &IBMLVL) TOPGMQ(*PRV)
         ENDDO
 
/*/COPY WNCPYSRC,UTC0280MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,UTC0280ERR                                          */
/* Abnormal termination */
 
             SNDPGMMSG  MSG('Program UTC0280 terminated abnormally') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,UTC0280END                                          */
 
 
             ENDPGM
