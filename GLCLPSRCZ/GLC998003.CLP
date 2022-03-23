/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Journal Entry Batch Monitor')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC998003 - Journal Entry Batch Monitor                     */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. MD059435 *CREATE   Date 16Feb22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD059435 - STP Batch entered Midas as held with an error    */
/*                  in the header record                             */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2022')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FOID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RUNEND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WAIT) TYPE(*CHAR) LEN(3)

/** Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Check if this job is already active */
/* End abnormally if it is */

             ALCOBJ     OBJ((GLBATMONLK *DTAARA *EXCLRD)) WAIT(2)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)

LOOP:        DLTF QTEMP/GLBTCHPD
             MONMSG     MSGID(CPF0000)
             DLTF QTEMP/GLBTCPPD
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(GLBTCHPD) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(GLBTCPPD) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(GLBTCHPD) TOFILE(QTEMP/GLBTCHPD) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(GLBTCPPD) TOFILE(QTEMP/GLBTCPPD) +
                          CRTFILE(*YES)
             OVRDBF     FILE(GLBTCHPD) TOFILE(QTEMP/GLBTCHPD) +
                          OVRSCOPE(*JOB)
             OVRDBF     FILE(GLBTCPPD) TOFILE(QTEMP/GLBTCPPD) +
                          OVRSCOPE(*JOB)

/* Get Batch APOUTPUTPD data */

             CALL       PGM(GL998001) PARM(&RTCD)
             IF         COND(&RTCD *NE '  ') THEN(GOTO CMDLBL(ABNOR))

/* Extract Batches from APOUTPUTPD */

             CALL       PGM(GL998002) PARM(&RTCD &FOID)
             IF         COND(&RTCD *NE '  ') THEN(GOTO CMDLBL(ABNOR))

/* Validate Batches from APOUTPUTPD */

             CALL       PGM(GL998003) PARM(&RTCD)
             IF         COND(&RTCD *NE '  ') THEN(GOTO CMDLBL(ABNOR))

/* Check DTAARA GLBATMONST */
             RTVDTAARA  DTAARA(GLBATMONST (1 4)) RTNVAR(&PARM)
             CHGVAR     VAR(&RUNEND) VALUE(%SST(&PARM 1 1))
/* Instruction to end */
             IF         COND(&RUNEND *EQ 'E') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

/* Complete Batches From APOUTPUTPD */

             CALL       PGM(GL998004) PARM(&RTCD)
             IF         COND(&RTCD *NE '  ') THEN(GOTO CMDLBL(ABNOR))

             DLTOVR     FILE(GLBTCHPD) LVL(*JOB)
             DLTOVR     FILE(GLBTCPPD) LVL(*JOB)

/* Check DTAARA GLBATMONST */
             RTVDTAARA  DTAARA(GLBATMONST (1 4)) RTNVAR(&PARM)
             CHGVAR     VAR(&RUNEND) VALUE(%SST(&PARM 1 1))
/* Instruction to end */
             IF         COND(&RUNEND *EQ 'E') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

             CHGVAR     VAR(&WAIT) VALUE(%SST(&PARM 2 3))
             IF         COND(&WAIT *EQ '   ' *OR &WAIT *EQ '000') +
                          THEN(GOTO CMDLBL(ABNOR))

/* Wait for an interval */
             DLYJOB     DLY(&WAIT)

/* Check DTAARA GLBATMONST */
             RTVDTAARA  DTAARA(GLBATMONST (1 4)) RTNVAR(&PARM)
             CHGVAR     VAR(&RUNEND) VALUE(%SST(&PARM 1 1))
/* Instruction to end */
             IF         COND(&RUNEND *EQ 'E') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

             GOTO       CMDLBL(LOOP)

/**/
 ABNOR:      SNDPGMMSG  MSG('GLC998003 - BATCH MONITOR TERMINATED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDP:       DLCOBJ     OBJ((GLBATMONLK *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra +
                          International Limited')
             ENDPGM
