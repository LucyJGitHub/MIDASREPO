/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cashier TCP/IP listener')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4500 - Midas Cashier TCP/IP Listener                     */
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
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CRT004  *CREATE    Date 10May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - Set authorities for data queues.                   */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BRC &PORT)
 
/*/COPY WNCPYSRC,REC4500INT                                          */
 
             DCL        VAR(&BRC) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PORT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DTAARAJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAARAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)                                 /*CPK015*/
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)                                   /*CPK015*/
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBINF) TYPE(*CHAR) LEN(26)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC4500MPS                                          */
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
 
/* Create Working Data area and Data queues if required */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
 
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *TCAT 'DPLIB')                         /*CPK015*/
 
/* Create dataarea name */
             CHGVAR     VAR(&DTAARAL) VALUE('RE4500L' *TCAT &BRC)
/* Lock Data area to prevent another listener job for the same bracnh */
             ALCOBJ     OBJ((&DPLIB/&DTAARAL *DTAARA *EXCL)) WAIT(0)
 
             MONMSG     MSGID(CPF1085) EXEC(DO)
             CRTDTAARA  DTAARA(&DPLIB/&DTAARAL) TYPE(*CHAR) LEN(128) +
                          TEXT('Midas Cashier TCP/IP Lock Data Area +
                          for Listener') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
             ENDDO
 
             CHGVAR     VAR(&DTAARAJ) VALUE('RE4500J' *TCAT &BRC)
             CHGVAR     VAR(&DTAQ) VALUE('RE4500' *TCAT &BRC)
 
             CRTDTAARA  DTAARA(&DPLIB/&DTAARAJ) TYPE(*CHAR) LEN(128) +
                          TEXT('Midas Cashier TCP/IP Job Data Area +
                          for Listener') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
/* Retrieve job information and store. */
             RTVJOBA    JOB(&JOBNAME) USER(&JOBUSER) NBR(&JOBNO)
             CHGVAR     VAR(&JOBINF) VALUE(&JOBNAME *CAT &JOBUSER +
                          *CAT &JOBNO)
             CHGDTAARA  DTAARA(&DPLIB/&DTAARAJ) VALUE(&JOBINF)
 
/************DLTDTAQ    DTAQ(&DPLIB/&DTAQ)                                                /*CPK015*/
/************MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
/************CRTDTAQ    DTAQ(&DPLIB/&DTAQ) MAXLEN(26) SEQ(*FIFO) +                        /*CPK015*/
/************             TEXT('Midas Cashier TCP/IP Data Queue for +                     /*CPK015*/
/************             Listener') AUT(*ALL)                                            /*CPK015*/
/************MONMSG     MSGID(CPF9870)                                                    /*CPK015*/
             CHKOBJ     OBJ(&DTAQLIB/&DTAQ) OBJTYPE(*DTAQ)                                /*CPK015*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CPK015*/
                CRTDTAQ    DTAQ(&DTAQLIB/&DTAQ) MAXLEN(26) SEQ(*FIFO) +
                             TEXT('Midas Cashier TCP/IP Data Queue for +
                             Listener')                                                   /*CPK015*/
                RTVOBJD    OBJ(&DTAQLIB) OBJTYPE(*LIB) OWNER(&OWNER)                      /*CPK015*/
                CHGOBJOWN  OBJ(&DTAQLIB/&DTAQ) OBJTYPE(*DTAQ) +
                             NEWOWN(&OWNER)                                               /*CPK015*/
             ENDDO                                                                        /*CPK015*/
             CALL       PGM(QCLRDTAQ) PARM(&DTAQ &DTAQLIB)                                /*CPK015*/
 
/* Call Listener job */
             CALL       PGM(RE4500) PARM(&BRC &PORT)
 
/*/COPY WNCPYSRC,REC4500MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC4500ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4500 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC4500END                                          */
 
             ENDPGM
