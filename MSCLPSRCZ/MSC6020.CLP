/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MS Merva/2 - Incoming Messages Rx')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - SWIFT direct link                               */
/*                                                                   */
/*       MSC6020 - Merva/2 Incoming Message Reception                */
/*                                                                   */
/*       Written for S01431 - Midas to Merva/2 interface             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                       089842           DATE 19DEC97               */
/*                       068102           DATE 24MAR94               */
/*                                                                   */
/*---------------------------------------------------------------- --*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   CCB020 - COB Restructure - Secondary COB Infrastructure         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*   089842 - Send a break message only if the program is running    */
/*            interactively, else just send a message to the msg     */
/*            queue.                                                 */
/*   068102 - Place job name into MEDTA for enquiry program          */
/*                                                                   */
/*********************************************************************/
 
/* Parameter &JOB used to send termination message to submitting w/s */
             PGM        PARM(&JOB)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NAR) TYPE(*CHAR) LEN(70)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                         */  /*089842 CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/* */                                                                 /*068102*/
/* Variables for job information */                                   /*068102*/
/* */                                                                 /*068102*/
             DCL        VAR(&JOB1) TYPE(*CHAR) LEN(10)                /*068102*/
             DCL        VAR(&USER1) TYPE(*CHAR) LEN(10)               /*068102*/
             DCL        VAR(&JOBNBR1) TYPE(*CHAR) LEN(6)              /*068102*/
/************DCL********VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +*/
/*************************COPYRIGHT MKI +                            */
/*************************INTERNATIONAL LTD. 1993')                  */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/**Retrieve*MPHAS*Data*Area**/                                                     /*089842 CCB020*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*089842 CCB020*/
/**/                                                                                      /*CCB020*/
/** CBFLAGQT PHASE CHECK  **/                                                             /*CCB020*/
/**/                                                                                      /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
                                                                      /*089842*/
/* Allocate data area MS6020 to show that program is active         */
             ALCOBJ     OBJ((MS6020 *DTAARA *EXCL))
 
/* Override API profile file to approriate member for MS6020        */
             OVRDBF     FILE(MSPRFIPD) MBR(PRF)
 
/* Create Local Data Area (LDA)                                     */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
 
/* Set-off Database Error Switches and set the job run priority     */
             CHGJOB     RUNPTY(19) SWS(XXXXXX00)
 
/* Create the EPM environment                                       */
             SETPGMINF  ROOTPGM(ENM4RRPG) SUBPGM((ENM4RAPI) +
                          (ENM4RUTL) (ENM4RPRF) (ENM4SNIL))
 
/* Begin commitment control                                         */
/**********  STRCMTCTL  LCKLVL(*ALL)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*ALL) CMTSCOPE(*JOB)                   /*CPK009*/
/* */                                                                 /*068102*/
/* Set up job information */                                          /*068102*/
/* */                                                                 /*068102*/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)         /*068102*/
             CHGDTAARA  DTAARA(MEDTA (441 26)) VALUE(&JOB1 *CAT +
                          &USER1 *CAT &JOBNBR1)                       /*068102*/
 
/* Call MS6020 to begin communications with Merva/2 device          */
             CALL       PGM(MS6020) PARM(&RC &NAR)
 
/* If switches are on, process database error                       */
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)    */        /*089842*/
             IF         COND(%SWITCH(XXXXXX11) *AND (&RC *EQ +
                          'NOER')) THEN(DO)                           /*089842*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(GBMIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
/* If the return code is not 'NOER'                                 */
/* an error has occurred                                            */
/* so send a message to                                             */
/* the submitting user's workstation                                */
/* If program is running in batch, send the message to MOPERQ    */   /*089842*/
/* and MRUNQ instead.                                            */   /*089842*/
             IF         COND(&RC *NE 'NOER') THEN(DO)
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)                           */ /*089842 CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(DO)                                   /*CCB020*/
             SNDBRKMSG  MSG('Midas to Merva/2 Incoming Reception has +
                          terminated abnormally with error code:' +
                          *BCAT &RC *BCAT &NAR) TOMSGQ(&JOB)
             MONMSG     MSGID(CPF0000)
             ENDDO
             ELSE       CMD(DO)                                       /*089842*/
             SNDBRKMSG  MSG('Midas to Merva/2 Incoming Reception has +
                          terminated abnormally with error code:' +
                          *BCAT &RC *BCAT &NAR) TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*089842*/
             MONMSG     MSGID(CPF0000)                                /*089842*/
             ENDDO                                                    /*089842*/
             ENDDO                                                    /*089842*/
 
             GOTO       CMDLBL(END)
 
 ERROR:      SNDPGMMSG  MSG('Midas to Merva/2 Incoming Reception +
                          component ended abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:        DLCOBJ     OBJ((MS6020 *DTAARA *EXCL))
             MONMSG MSGID(CPF0000 MCH0000)
             ENDCMTCTL
             MONMSG MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
