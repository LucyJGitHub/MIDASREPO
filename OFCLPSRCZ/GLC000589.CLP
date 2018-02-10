/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas GL Journal posting')                            */
/********************************************************************/
/*                                                                  */
/*       Midas GENERAL LEDGER MODULE                                */
/*                                                                  */
/*       GLC000589 - REAL TIME POSTINGS                             */
/*                                                                  */
/*       (c) Finastra International Limited 2014                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD028241           Date 19Aug14              */
/*                      MD025973 *CREATE   Date 25Mar14              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       MD028241 - Real Time processing rollback issue.            */
/*       MD025973 - Intermitent Generation of Movement in MT940     */
/*                                                                  */
/********************************************************************/
 
/**********  PGM        PARM(&BNUM &WRKSTN)                **********/                  /*MD028241*/
             PGM        PARM(&BNUM)                                                     /*MD028241*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2014')
 
             DCL        VAR(&BNUM) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&WRKSTN) TYPE(*CHAR) LEN(10)   **********/                  /*MD028241*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GLUSRMSG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACC) TYPE(*CHAR) LEN(18)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRGC)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&CMC001) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
 
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
/* Override MSGF/MIDAS to appropriate language */
 
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)
             IF         COND(&MULT *EQ '  ') THEN(DO)
             CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
 
             CHGVAR     VAR(&MIDAS) VALUE(&MULT *CAT 'MIDAS')
             CHGVAR     VAR(&GLUSRMSG) VALUE(&MULT *CAT 'GLUSRMSG')
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDAS)
             OVRMSGF    MSGF(GLUSRMSG) TOMSGF(&GLUSRMSG)
 
/* Create LDA if it does not already exist */
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
 
 
/*  Check if Management Accounts Enhancement is installed.         */
 
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CMC001' +
                          &DSFDY)
/* */
/*  If Management Accounts Enhancement is installed, exclusively   */
/*  allocate DTAARA/MC0220 to indicate that mgmt a/cs are in use   */
/* */
             IF         COND(&RTCD *EQ ' ') THEN(DO)
                CHGVAR     VAR(&CMC001) VALUE('Y')
                ALCOBJ     OBJ((MC0220 *DTAARA *EXCLRD)) WAIT(0)
                MONMSG     MSGID(CPF1002) EXEC(DO)
                SNDPGMMSG  MSG('Management accounts files cannot  +
                             be allocated at this time.') +
                             TOMSGQ(MRUNQ)                                              /*MD028241*/
/**********                  TOMSGQ(MRUNQ &WRKSTN)         **********/                  /*MD028241*/
                SNDPGMMSG  MSG('Transaction failed. Re-input +
                             necessary.') TOMSGQ(MOPERQ)                                /*MD028241*/
/**********                  necessary.') TOMSGQ(&WRKSTN MOPERQ) **********/            /*MD028241*/
                ROLLBACK
                CALL PGM(GL0451) PARM(&BNUM)
                GOTO       CMDLBL(ENDPGM)
                ENDDO
                DLYJOB     DLY(1)
             ENDDO
 
 
/* Check if CGL135 is installed */
 
             CHGVAR     VAR(&PRTCD) VALUE('       ')
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&PSARD) VALUE('CGL135')
 
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)
 
             IF         COND(&PRTCD *EQ '       ') THEN(DO)
/* Call GL000594 to create non existing Accounts                    */
             CALL       PGM(GL000594) PARM(&PRTCD &BNUM)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             ROLLBACK
             CALL       PGM(GL0451) PARM(&BNUM)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             ENDDO
 
             OVRDBF     FILE(ACCNTX) TOFILE(ACCNT) SHARE(*NO)
 
             CALL PGM(GL0450) PARM(&BNUM)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('Transaction failed. Re-input +
                          necessary. Enter to continue.') +
                          TOMSGQ(MOPERQ)                                                /*MD028241*/
/**********               TOMSGQ(&WRKSTN MOPERQ)           **********/                  /*MD028241*/
                ROLLBACK
                CALL PGM(GL0451) PARM(&BNUM)
             ENDDO
 
             DLTOVR     FILE(ACCNTX)
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               ROLLBACK
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
               CHGVAR     VAR(&ACC) VALUE(%SUBSTRING(&LDA 153 18))
               CHGVAR     VAR(&ERR) VALUE(%SUBSTRING(&LDA 181 3))
               IF         COND(&ERR *EQ '009') THEN(DO)
                 SNDPGMMSG  MSGID(USR1001) MSGF(GLUSRMSG) MSGDTA(&ACC) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)                               /*MD028241*/
/**********                   TOPGMQ(*EXT) TOMSGQ(&WRKSTN MOPERQ) **********/           /*MD028241*/
               ENDDO
               ELSE       CMD(DO)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                 /*MD028241*/
/**********                 TOPGMQ(*EXT) TOMSGQ(&WRKSTN MOPERQ)   **********/           /*MD028241*/
               ENDDO
 
               CALL PGM(GL0451) PARM(&BNUM)
               IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
               ENDDO
             GOTO       CMDLBL(ABNOR)
             ENDDO
/* */
/*  If Management Accounts Enhancement is installed, call MCC0310  */
/*  to filter the Manual entries to MCMOVEPD.                      */
/* */
             IF         COND(&CMC001 *EQ 'Y') THEN(DO)
 
                CLRPFM     FILE(MCMOVEPD)
                CLRPFM     FILE(MCPST1PD)
                CALL       PGM(MCC0310) PARM('GERTPD')
                IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                   CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
                CPYF       FROMFILE(MCMOVEPD) TOFILE(MCPST1PD) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(MCPST1PD))
/* */
/*  Update the management accounts using the Real Time Posting     */
/* */
                CALL       PGM(MCC0350) PARM('1' 'MCC0350' +
                             X'00001F')
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   CALL       PGM(CB0160) PARM('MCC0350' X'00001F' +
                                &BUSY)
/* */
/*  If busy flag is 'Y', recover original version of Management    */
/*  Accounts files GLHIBLPD and GLAVBLPD                           */
/* */
                   IF         COND(&BUSY *EQ 'Y') THEN(DO)
                      CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' +
                                   &DSFDY)
                      CHGVAR     VAR(&PRGC) VALUE(%SST(&DSFDY 15 2))
                      CPYF       FROMFILE(XGLHIBLPD) TOFILE(GLHIBLPD) +
                                   FROMMBR(&PRGC) TOMBR(*FROMMBR) +
                                   MBROPT(*REPLACE)
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GLHIBLPD) +
                                   MBR(&PRGC))
                      CPYF       FROMFILE(XGLAVBLPD) TOFILE(GLAVBLPD) +
                                   FROMMBR(&PRGC) TOMBR(*FROMMBR) +
                                   MBROPT(*REPLACE)
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GLAVBLPD) +
                                   MBR(&PRGC))
                      CALL       PGM(CB0150) PARM('MCC0350' +
                                   X'00001F' 'N')
                      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                      CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOPGMQ(*EXT) +
                                   TOMSGQ(MOPERQ MRUNQ)
                   ENDDO
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
                DLCOBJ     OBJ((MC0220 *DTAARA *EXCLRD))
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             SNDPGMMSG  MSGID(USR1002) MSGF(GLUSRMSG) MSGDTA(&BNUM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)                             /*MD028241*/
 /**********              TOPGMQ(*EXT) TOMSGQ(&WRKSTN MOPERQ MRUNQ) **********/         /*MD028241*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
