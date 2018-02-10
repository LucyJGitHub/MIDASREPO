/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Testkey request by destination')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - TELEX INTERFACE                             */
/*                                                                   */
/*       MTC4020 - TESTKEY REQUEST BY DESTINATION                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 176843             Date 01Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTK001             Date 13May99              */
/*                      E32895      DATE 30APR92                     */
/*                      00000       DATE 00XXX00                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       176843 - Create a working copy of TKII interface file       */
/*                within QTEMP and process this one instead of       */
/*                that in xxDMLIB to prevent problems.               */
/*       CTK001 - Testkey module conversion from DOS to WINDOWS      */
/*                95/NT (Testkey II)                                 */
/*       E32895 - THE PROGRAM SHOULD SEND ADDITIONAL INFORMATION IF  */
/*                JOB IS NOT BEING RUN  FROM A VALID PC DEVICE.      */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&X) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&Y) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)                /*CTK001*/
             DCL       VAR(&RETCOD) TYPE(*CHAR) LEN(7) VALUE(' ')     /*CTK001*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*CTK001*/
             DCL       VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CTK001')  /*CTK001*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(200)                 /*CTK001*/
             DCL       VAR(&CTK001) TYPE(*CHAR) LEN(1) VALUE('N')     /*CTK001*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&N#ZTK) TYPE(*CHAR) LEN(100)
 
/**  Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
/**  Set-off Data Base Error Switches */
             CHGJOB     SWS(XXXXXX00)
 
/**  If Testkey interface present */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SST(&MMOD 58 1) *EQ 'Y') THEN(DO)
                                                                      /*CTK001*/
/** Check if Testkey II (for Windows NT) is installed */              /*CTK001*/
                                                                      /*CTK001*/
            CALL   PGM(AOSARDR0) PARM(&RETCOD &OPTN &SARD &FMT)       /*CTK001*/
                                                                      /*CTK001*/
            IF     COND(&RETCOD *EQ '       ') THEN(CHGVAR +
                    VAR(&CTK001) VALUE('Y'))                          /*CTK001*/
 
             RMVLIBLE   LIB(QTEMP)
             MONMSG     MSGID(CPF0000)
 
/**  Copy TKOTIPF and TKOTOPF to QTEMP */
             CPYF       FROMFILE(TKOTIPF) TOFILE(QTEMP/TKOTIPF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
             CPYF       FROMFILE(TKOTOPF) TOFILE(QTEMP/TKOTOPF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
/**/                                                                  /*176843*/
/** Create a copy of TKIBCKPD to QTEMP */                             /*176843*/
/**/                                                                  /*176843*/
             CPYF       FROMFILE(TKIBCKPD) TOFILE(QTEMP/TKIBCKPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*176843*/
             MONMSG     MSGID(CPF2817)                                /*176843*/
 
             ADDLIBLE   LIB(QTEMP) POSITION(*FIRST)
 
/**/                                                                  /*CTK001*/
/** If Testkey 2000 is installed, check for validity of User ID    */ /*CTK001*/
/** instead of the PC device name and DO NOT use STRPCO            */ /*CTK001*/
/**/                                                                  /*CTK001*/
             IF     COND(&CTK001 *EQ 'Y') THEN(DO)                    /*CTK001*/
/**/                                                                  /*CTK001*/
             RTVJOBA    USER(&NAME)                                   /*CTK001*/
/** Retrieve valid testkey users from the configuration data area  */ /*CTK001*/
             RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)                  /*CTK001*/
                                                                      /*CTK001*/
/**/                                                                  /*CTK001*/
LOOP1:       CHGVAR     VAR(&USID) VALUE(%SUBSTRING(&N#ZTK &X 10))    /*CTK001*/
             IF         COND(&NAME *EQ &USID) THEN(GOTO PCONO)        /*CTK001*/
/**/                                                                  /*CTK001*/
             IF         COND(&Y *EQ 9) THEN(DO)                       /*CTK001*/
             SNDPGMMSG  MSG('Testkey Request By Destination must +
                        be ran by a valid Midas Testkey user.') +
                        TOMSGQ(MOPERQ) TOPGMQ(*EXT)                   /*CTK001*/
             GOTO       CMDLBL(END)                                   /*CTK001*/
             ENDDO                                                    /*CTK001*/
/**/                                                                  /*CTK001*/
             CHGVAR     VAR(&Y) VALUE(&Y + 1)                         /*CTK001*/
             CHGVAR     VAR(&X) VALUE(&X + 10)                        /*CTK001*/
             GOTO LOOP1                                               /*CTK001*/
/**/                                                                  /*CTK001*/
             ENDDO                                                    /*CTK001*/
/**/                                                                  /*CTK001*/
                                                                      /*CTK001*/
/** If Testkey 2000 not installed, process using STRPCO.              /*CTK001*/
                                                                      /*CTK001*/
             IF     COND(&CTK001 *EQ 'N') THEN(DO)                    /*CTK001*/
                                                                      /*CTK001*/
/**  Is job valid testkey PC device name on N#ZTK data area */
             RTVJOBA    JOB(&NAME)
             RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)
 
LOOP:        CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&N#ZTK &X 10))
             IF         COND(&NAME *EQ &WSID) THEN(GOTO PCOYES)
/************IF         COND(&Y *EQ 9) THEN(GOTO ABNOR)              /*E32895*/
             IF         COND(&Y *EQ 9) THEN(DO)                      /*E32895*/
             SNDPGMMSG  MSG('JOB MUST BE RUN FROM A VALID +
                        PC DEVICE') TOPGMQ(*EXT)                     /*E32895*/
             GOTO       CMDLBL(ABNOR)                                /*E32895*/
             ENDDO                                                   /*E32895*/
             CHGVAR     VAR(&Y) VALUE(&Y + 1)
             CHGVAR     VAR(&X) VALUE(&X + 10)
             GOTO LOOP
 
/** Start PC Support Organiser */
PCOYES:      STRPCO
             MONMSG     MSGID(IWS4010) EXEC(GOTO CMDLBL(PCONO))
             DLYJOB     DLY(15)
/**/                                                                  /*CTK001*/
             ENDDO                                                    /*CTK001*/
/**/                                                                  /*CTK001*/
/*           STRPCCMD   PCCMD('C:\PCS\TKINIT') PAUSE(*NO) */
 
/* CALL PROGRAM TO SOAK UP 'GO PCOMNU' COMMAND WHICH IS SENT TO */
/* DISPLAY BUFFER WHEN STRPCCMD IS RUN FOR FIRST TIME           */
/*           CALL MT1239 */
 
/* Call Input Cycle Enquiry Program. */
PCONO:       CALL MT4020
 
/* For Database Errors Recover Data From Local Data Area, Send */
/* Message to MOPERQ. */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
             ENDDO
 
             GOTO END
ABNOR:       SNDPGMMSG  MSG('TESTKEY REQUEST BY DESTINATION +
                        ENDED ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CLRPFM     FILE(TKOTOPF)                                                     /*CTK001*/
             CLRPFM     FILE(TKIBCKPD)                                                    /*176843*/
             ENDPGM
