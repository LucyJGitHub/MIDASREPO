/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MS Merva/2 - End Communications')               */
/********************************************************************/
/*                                                                  */
/*       Midas     - SWIFT direct link                              */
/*                                                                  */
/*       MSC6002 - End Merva/2 communications                       */
/*                                                                  */
/*       Written for S01431 - Midas to Merva/2 interface            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      075968             Date 14Sep94              */
/*                       Xnnnnn           DATE nnXXXnn              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       075968  -  Terminate transmission and reception programs   */
/*                  separately, checking that each is active first; */
/*                  do not send any program messsages unless this   */
/*                  program is called from input cycle.             */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NAR) TYPE(*CHAR) LEN(70)
             DCL        VAR(&TXACT) TYPE(*CHAR) LEN(1) VALUE('N')     /*075968*/
             DCL        VAR(&RXACT) TYPE(*CHAR) LEN(1) VALUE('N')     /*075968*/
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)             */              /*075968 CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                                          /*CCB020*/
/* Parameter for call to CBC001001 */                                                     /*CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
 
/*********** DCLF       FILE(SDMGMEPD)                            */ /*075968*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/**Obtain*MPHAS*****************************************************/              /*075968 CCB020*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)               */              /*075968 CCB020*/
                                                                                          /*CCB020*/
/* Call program CBC001001 to check if program is in COB or IC */                          /*CCB020*/
/* If the return value is *YES, system is in COB */                                       /*CCB020*/
/* If *NO, system is in Input Cycle */                                                    /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
 
/* Override API profile file to approriate member for MS6002        */
             OVRDBF     FILE(MSPRFTPD) MBR(PRF)
 
/**Check*whether*the*communications*program*is*all*ready*active****** /*075968*/
/**by*trying*to*allocate*its*data*area******************************* /*075968*/
/*********** ALCOBJ     OBJ((MS6010 *DTAARA *EXCL)) WAIT(1)         * /*075968*/
/*********** MONMSG     MSGID(CPF1002) EXEC(DO)                     * /*075968*/
 
/* Check whether the communications programs are all ready active   * /*075968*/
/* by trying to allocate their data areas                           * /*075968*/
             ALCOBJ     OBJ((MS6010 *DTAARA *EXCL)) WAIT(1)           /*075968*/
             MONMSG     MSGID(CPF1002) EXEC(CHGVAR VAR(&TXACT) +
                          VALUE('Y'))                                 /*075968*/
 
             ALCOBJ     OBJ((MS6020 *DTAARA *EXCL)) WAIT(1)           /*075968*/
             MONMSG     MSGID(CPF1002) EXEC(CHGVAR VAR(&RXACT) +
                          VALUE('Y'))                                 /*075968*/
 
/* If the data area could not be allocated                          */
/* then the communications programs are active                      */
/* (as they have the data area allocated to them)                   */
 
/* Get job name for communications job termination messages         */
             RTVJOBA    JOB(&JOB)
 
/* End outgoing transmission processing                             */
/* if it is active                                                  * /*075968*/
             IF         COND(&TXACT *EQ 'Y') THEN(DO)                 /*075968*/
             CALL       PGM(QSNDDTAQ) PARM(MSDTQA *LIBL X'00001F' T)
 
/* Wait for the transmission program to complete termination        */
             ALCOBJ     OBJ((MS6010 *DTAARA *EXCL)) WAIT(300)
             MONMSG     MSGID(CPF1002) EXEC(DO)
 
/* If the data area cannot be allocated                              */
/* then the program has not terminated successfully                  */
/* (and hence relinquished control of the data area)                 */
             CHGVAR     VAR(&MESSAGE) VALUE('Midas to Merva/2 link +
                          termination unsuccessful')
/**********  CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE) */  /*CCB001*/
/**********  CALL       PGM(SCC0010) PARM('MSC6002' 'ENTER' ' ')  */  /*CCB001*/
/**********  GOTO       CMDLBL(END)                               */  /*CCB001*/
             SNDPGMMSG  MSG(&MESSAGE) TOMSGQ(MOPERQ)                  /*CCB001*/
             GOTO       CMDLBL(ERROR)                                 /*CCB001*/
             ENDDO
             ENDDO                                                    /*075968*/
 
/**If*'Outgoing*Only'*flag*on*ICD*is*'N'*(No)*then*end*************** /*075968*/
/**incoming*message*reception**************************************** /*075968*/
/*********** RCVF                                                  */ /*075968*/
 
/*********** IF         COND(&ENOGON *EQ 'N') THEN(DO)             */ /*075968*/
 
/* End the reception processing if it is active                     * /*075968*/
             IF         COND(&RXACT *EQ 'Y') THEN(DO)                 /*075968*/
             CALL       PGM(MS6002) PARM(&RC &NAR)
 
/* Wait for the reception program to complete termination           */
             ALCOBJ     OBJ((MS6020 *DTAARA *EXCL)) WAIT(600)
             MONMSG     MSGID(CPF1002) EXEC(DO)
 
/* If the data area cannot be allocated                              */
/* then the program has not terminated successfully                  */
/* (and hence relinquished control of the data area)                 */
             CHGVAR     VAR(&MESSAGE) VALUE('Midas to Merva/2 link +
                          termination unsuccessful')
/**********  CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE) */  /*CCB001*/
/**********  CALL       PGM(SCC0010) PARM('MSC6002' 'ENTER' ' ')  */  /*CCB001*/
/**********  GOTO       CMDLBL(END)                               */  /*CCB001*/
             SNDPGMMSG  MSG(&MESSAGE) TOMSGQ(MOPERQ)                  /*CCB001*/
             GOTO       CMDLBL(ERROR)                                 /*CCB001*/
             ENDDO
 
             ENDDO
 
/**If*all*went*well************************************************** /*075968*/
/**then*terminate**************************************************** /*075968*/
/*********** IF         COND((&RC *EQ 'NOER') *OR (&ENOGON *EQ 'Y')) +
/***********              THEN(GOTO CMDLBL(END))                   */ /*075968*/
 
/*********** ENDDO                                                 */ /*075968*/
 
/* If communications are not active                                  */
/* -that is, the data area could be allocated-                       */
/* and this program has been called from input cycle                * /*075968*/
/* send a message and terminate                                      */
/**********  IF         COND((&RXACT *EQ 'N') *AND (&TXACT *EQ 'N') +                     /*CCB020*/
/**********               *AND (&MPHAS *EQ 'A')) THEN(DO)          */              /*075968 CCB020*/
             IF         COND((&RXACT *EQ 'N') *AND (&TXACT *EQ 'N') +
                          *AND (&COBST = '*NO')) THEN(DO)                                 /*CCB020*/
             CHGVAR     VAR(&MESSAGE) VALUE('Midas to Merva/2 +
                          communications are not active')
/**********  CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)     /*CCB001*/
/**********  CALL       PGM(SCC0010) PARM('MSC6002' 'ENTER' ' ')      /*CCB001*/
             SNDPGMMSG  MSG(&MESSAGE) TOMSGQ(MOPERQ)                  /*CCB001*/
             GOTO       CMDLBL(ERROR)                                 /*CCB001*/
             ENDDO                                                    /*075968*/
 
             GOTO       CMDLBL(END)
 
/*RROR:****  SNDPGMMSG  MSG('Midas to Merva/2 communications +        /*CCB001*/
/**********               termination ended abnormally') +            /*CCB001*/
/**********               TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*CCB001*/
 ERROR:                                                               /*CCB001*/
             SNDPGMMSG  MSG('Midas to Merva/2 communications +
                          termination ended abnormally') +
                          TOMSGQ(MOPERQ)                              /*CCB001*/
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)                                 /*CCB001*/
                                                                      /*CCB001*/
 END:        DLCOBJ     OBJ((MS6010 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MS6020 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
             ENDEPMENV  EPMENV(ENM4RRPG)
             MONMSG     MSGID(CPF0000 PSE0000 MCH0000 RPG0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
