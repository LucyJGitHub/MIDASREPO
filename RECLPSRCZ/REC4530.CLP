/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cashier TCP/IP socket debug stop/start')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4530 - Midas Cashier TCP/IP Socket Debugging Stop/Start  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 25Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CRT004  *CREATE    Date 12May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPTION)
 
/*/COPY WNCPYSRC,REC4530INT                                          */
 
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                 */ /*CPK015*/
/************DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                */ /*CPK015*/
/************DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)                                 */ /*CPK015*/
             DCL        VAR(&RE4540DA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&DBGLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DBGJNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBGJUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBGJNB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,REC4530MPS                                          */
 
/* Main processing */
 
                RTVDTAARA  DTAARA(RE4540DA) RTNVAR(&RE4540DA)
                CHGVAR     VAR(&DBGLVL)  VALUE(%SST(&RE4540DA 1 1))
                CHGVAR     VAR(&DBGJNM)  VALUE(%SST(&RE4540DA 2 10))
                CHGVAR     VAR(&DBGJUS)  VALUE(%SST(&RE4540DA 12 10))
                CHGVAR     VAR(&DBGJNB)  VALUE(%SST(&RE4540DA 22 10))
 
/* STOP Process */
 
             IF         COND(&OPTION *EQ 'STOP      ') THEN(DO)
 
                ENDJOB     JOB(&DBGJNB/&DBGJUS/&DBGJNM) OPTION(*IMMED)
                MONMSG     MSGID(CPF0001 CPF1321 CPF1362)
 
                CHGVAR     VAR(%SST(&RE4540DA 1 1)) VALUE('N')
                CHGVAR     VAR(%SST(&RE4540DA 2 10)) VALUE(' ')
                CHGVAR     VAR(%SST(&RE4540DA 12 10)) VALUE(' ')
                CHGVAR     VAR(%SST(&RE4540DA 22 10)) VALUE(' ')
                CHGDTAARA  DTAARA(RE4540DA) VALUE(&RE4540DA)
 
             ENDDO
 
/* START Process */
             IF         COND(&OPTION *EQ 'START     ') THEN(DO)
 
                IF         COND(&DBGLVL *NE 'Y') THEN(DO)
 
/************      RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                      */ /*CPK015*/
/************      CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB')                  */ /*CPK015*/
/************      CHGVAR     VAR(&DTAQ) VALUE('RE4540DQ')                             */ /*CPK015*/
/************      CRTDTAQ    DTAQ(&DPLIB/&DTAQ) MAXLEN(1000) SEQ(*FIFO) +             */ /*CPK015*/
/************             SENDERID(*YES) TEXT('Midas Cashier TCP/IP +                  */ /*CPK015*/
/************             Data Queue for Debugger') AUT(*ALL)                          */ /*CPK015*/
/************      MONMSG     MSGID(CPF9870)                                           */ /*CPK015*/
 
                   CHGVAR     VAR(%SST(&RE4540DA 1 1)) VALUE('Y')
                   CHGVAR     VAR(%SST(&RE4540DA 2 10)) VALUE(' ')
                   CHGVAR     VAR(%SST(&RE4540DA 12 10)) VALUE(' ')
                   CHGVAR     VAR(%SST(&RE4540DA 22 10)) VALUE(' ')
                   CHGDTAARA  DTAARA(RE4540DA) VALUE(&RE4540DA)
 
/************SBMJOB     CMD(CALL PGM(REC4540)) JOB(TCP_DEBUG) +                           /*CPK014*/
/************             JOBD(CIJOBD) JOBQ(CIJOBQ) OUTQ(*JOBD) +                         /*CPK014*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                                    /*CPK014*/
                   SBMJOB     CMD(CALL PGM(REC4540)) JOB(TCP_DEBUG) +
                          JOBD(CIJOBD) JOBQ(CIJOBQ) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)                        /*CPK014*/
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                      CHGJOB     SWS(XXXXXX11)
                      CHGVAR     VAR(%SST(&RE4540DA 1 1)) VALUE('N')
                      CHGDTAARA  DTAARA(RE4540DA) VALUE(&RE4540DA)
                   ENDDO
 
                ENDDO
 
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,REC4530MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC4530ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4530 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC4530END                                          */
 
 
             ENDPGM
