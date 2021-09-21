/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Send prompt to ME FT IMM control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC1304  - Send Prompt to ME FT IMM Auto Gen Job            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD031937           Date 13Jan15              */
/*       Prev Amend No. AR856737           Date 13Sep11              */
/*                      HVB019             Date 05Dec11              */
/*                      ESL038             Date 04Oct2004            */
/*                      E00045             Date 08Jan2004            */
/*                      DJB100             Date 27Nov2002            */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      209318             Date 10Sep02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408            Date 05May95               */
/*                      S01435            DATE 21Sep93               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD031937 - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       HVB019   - DISABLE STP on Bank Holiday                      */
/*                  Prevent startup of STP if in DISABLE mode        */
/*       ESL038 - ING STP Development                                */
/*       E00045 - Suppress start of STP                              */
/*       DJB100 - Correct wait time for allocation                   */
/*       MD046248 - Finastra Rebranding                              */
/*       209318 - The ALCOBJ command for MEFTIMM should specify      */
/*                WAIT(0) not WAIT(60).                              */
/*       CPK015 - 4.01 packaging.  Use DPLIB and not DILIB.          */
/*       S01408 - Addition of core hook MEC1304MP1                   */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &MSG_REF &MSG_PRTY)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
/************DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)                                */ /*CPK015*/
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG_PRTY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEY_LEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&STP_STAT) TYPE(*CHAR) LEN(5)                                 /*HVB019*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1304 - Send Prompt to ME FT IMM Auto +
                          Gen Control') TOMSGQ(MRUNQ)
/**/
/**Construct*DILIB**/ /*                                                               */ /*CPK015*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)                         */ /*CPK015*/
/************CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')                      */ /*CPK015*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MEC1304MP1                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/                                                                                      /*E00045*/
/* Check for start up */                                                                  /*E00045*/
/**/                                                                                      /*E00045*/
/* Not used  CALL       PGM(MEP0050) PARM(&RTN_CODE)             */                     /*AR856737*/
/*           IF         COND(&RTN_CODE *NE '       ')  THEN(DO)  */                     /*AR856737*/
                                                                                          /*HVB019*/
/* Check if STP is DISABLED due to bank holiday. If DISABLED then do not start STP */     /*HVB019*/
             RTVDTAARA  DTAARA(MESTPSTAT) RTNVAR(&STP_STAT)                               /*HVB019*/
             IF         COND(&STP_STAT = 'DSBLD') THEN(DO)
             SNDPGMMSG  MSG('STP DISABLED - Today is holiday on +
                          PF/BVRHOLPF') TOMSGQ(MOPERQ MRUNQ)                              /*HVB019*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*HVB019*/
             GOTO       CMDLBL(ENDCLPGM)                                                  /*E00045*/
             ENDDO                                                                        /*E00045*/
/**/
/**Check*if*data*queue*exists**/                                                          /*CPK015*/
/**/
/**********  CALL       PGM(MEC1305) */                                                   /*CPK015*/
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
/************ALCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL)) WAIT(60)                     */ /*CPK015*/
/**********  ALCOBJ     OBJ((MEFTIMM *DTAQ *EXCL)) WAIT(60) */                 /*CPK015*/ /*209318*/
             ALCOBJ     OBJ((MEFTIMM *DTAQ *EXCL)) WAIT(0)                                /*209318*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(SEND)
             ENDDO
/**/
/* Start process */
/**/
             CALL       PGM(MEC1303) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'MIN0222')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Deallocate */
/**/
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL))                              */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *EXCL))                                        /*CPK015*/
/**/
/* Send data queue entry to prompt process */
/**/
 SEND:       CHGVAR     VAR(&DATA) VALUE(' ')
             CHGVAR     VAR(&DATA) VALUE(&MSG_REF)
/************CALL       PGM(QSNDDTAQ) PARM('MEFTIMM' &DILIB &FLDLEN +                  */ /*CPK015*/
/************             &DATA &KEY_LEN &MSG_PRTY)                                    */ /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('MEFTIMM' '*LIBL' &FLDLEN +
                          &DATA &KEY_LEN &MSG_PRTY)                                       /*CPK015*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL))                              */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *EXCL))                                        /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1304 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1304 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
