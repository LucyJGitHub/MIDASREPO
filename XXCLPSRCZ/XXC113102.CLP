/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME GCMS background task')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********MECJ002*-*GCMS Background Task*******************************/        /*JMI113*/
/*       XXC113102 - GCMS Background Task                            */        /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/        /*JMI113*/
/*       (c) Finastra International Limited 2018                     */        /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 22May18              */
/*       Prev Amend No. JMI019  *CREATE    Date 21Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Upgrade as is                                      */
/*       JMI019 - Midas GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM

/*             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI113*/
/**/
             DCL        VAR(&DAFTPP) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DTAQN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LNDTA) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DATA1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WAIT1) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LASTEXT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WRMO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WRDA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMIR) TYPE(*CHAR) LEN(10)
/**/
/** Global Error Trap                             */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/** Send message to MRUNQ                         */
/*           SNDPGMMSG  MSG('MECJ002 - GCMS Background Task') TOMSGQ(MRUNQ) */ /*JMI113*/
             SNDPGMMSG  MSG('XXC113102 - GCMS Background Task') TOMSGQ(MRUNQ) +
                          /*JMI113*/

/** Reset Job Switches                            */
             CHGJOB     SWS(XXXXXX00)
/**  Chech if DTAARA LDA exists                                      */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CRT))
             DLTDTAARA  DTAARA(QTEMP/LDA)
             MONMSG     MSGID(CPF2105)
        CRT:
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
/**/
/** Convert ASCII msg and create Index files      */
/**/
              CALL PGM(ZM0080) PARM(&RUNDAT &DATFMT)
              CHGVAR     VAR(&WRMO) VALUE(%SUBSTRING(&RUNDAT 3 2))
              CHGVAR     VAR(&WRDA) VALUE(%SUBSTRING(&RUNDAT 5 2))
/*            RTVDTAARA  DTAARA(MEGCMSDA) RTNVAR(&DAFTPP) */ /*JMI113*/
              RTVDTAARA  DTAARA(XXGCMMDA) RTNVAR(&DAFTPP) /*JMI113*/
/*           IF COND((%SST(&DAFTPP 31 2) *NE &WRMO) *AND +
                     (%SST(&DAFTPP 33 2) *NE &WRDA)) THEN(DO)      */
             IF COND((%SST(&DAFTPP 31 2) *NE &WRMO) *OR +
                     (%SST(&DAFTPP 33 2) *NE &WRDA)) THEN(DO)
/*            CHGDTAARA  DTAARA(MEGCMSDA (30 1)) VALUE('G')     */ /*JMI113*/
/*            CHGDTAARA  DTAARA(MEGCMSDA (31 2)) VALUE(&WRMO)   */ /*JMI113*/
/*            CHGDTAARA  DTAARA(MEGCMSDA (33 2)) VALUE(&WRDA)   */ /*JMI113*/
/*            CHGDTAARA  DTAARA(MEGCMSDA (35 5)) VALUE('00000') */ /*JMI113*/
                CHGDTAARA  DTAARA(XXGCMMDA (30 1)) VALUE('G') /*JMI113*/
                CHGDTAARA  DTAARA(XXGCMMDA (31 2)) VALUE(&WRMO) /*JMI113*/
                CHGDTAARA  DTAARA(XXGCMMDA (33 2)) VALUE(&WRDA) /*JMI113*/
                CHGDTAARA  DTAARA(XXGCMMDA (35 5)) VALUE('00000') /*JMI113*/
              ENDDO
/**/
/** Start GCMS Extraction                         */
             STRTPPEXT:
/*           ---------- */
/*            RTVDTAARA  DTAARA(MEGCMSDA) RTNVAR(&DAFTPP) */ /*JMI113*/
              RTVDTAARA  DTAARA(XXGCMMDA) RTNVAR(&DAFTPP) /*JMI113*/
/**/
/** Receive GCMS files flag is 'Y'                */
             IF COND(%SST(&DAFTPP 27 1) *EQ 'Y') THEN(DO)
/**/
/*           CALL       PGM(GLCJ014) PARM(&WAIT1) */ /*JMI113*/
                CALL       PGM(XXC113014) PARM(&WAIT1) /*JMI113*/

/**/
/***For*each*member*of*MGGCMSPD*retrieved**********/ /*JMI113*/
/** For each member of XXGCMGPD retrieved         */ /*JMI113*/
               FORMBTPPS:
/**            ----------                         */
/**/
/** Number of records null                        */

             CHGVAR     VAR(&PMIR) VALUE(*BLANKS)
/*           CALL       PGM(MEJ003) PARM(&PMIR) */ /*JMI113*/
             CALL       PGM(XX113103) PARM(&PMIR) /*JMI113*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 DMPCLPGM
                 RTVDTAARA  DTAARA(LDA (134 45)) RTNVAR(&ERRDTA)
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(ABNOR)

               ENDDO
             IF         COND(&PMIR *EQ '*EMPTY') THEN(DO)
             GOTO       CMDLBL(CHECK)
             ENDDO
               COMMIT
/**/
/**/
/***Retrieve*next*member*of*MGGCMSPD***************/ /*JMI113*/
/** Retrieve next member of XXGCMGPD              */ /*JMI113*/
               NXTMBTPPS:
/*             ---------- */
/**/
             ENDDO
/**/
/** Create Message Management files               */
/** Retrieve GCMS processing time from GCMS ICD   */
             CRTMMFILE:
/**           ----------                          */
/*           OVRDBF     FILE(MGGCMMPD) SHARE(*NO) */ /*JMI113*/
             OVRDBF     FILE(XXGCMMPD) SHARE(*NO) /*JMI113*/
/*             CALL       PGM(MEJ004) PARM(&WAIT1) */ /*JMI113*/
             CALL       PGM(XX113104) PARM(&WAIT1) /*JMI113*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               DMPCLPGM
               RTVDTAARA  DTAARA(LDA (134 45)) RTNVAR(&ERRDTA)
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                        TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)

             ENDDO

             CHECK:
/**/
/** The last extraction has been processed        */
             IF         COND(&LASTEXT *EQ 'Y') THEN(DO)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/** Receive dtaq info                             */
/*             CHGVAR     VAR(&DTAQN) VALUE('MEGCMSDA') */ /*JMI113*/
             CHGVAR     VAR(&DTAQN) VALUE('MEGCMSDA') /*JMI113*/
             CHGVAR     VAR(&LIBRN) VALUE('*LIBL')
             CHGVAR     VAR(&LNDTA) VALUE(1)
             CHGVAR     VAR(&DATA1) VALUE(' ')
             CALL       PGM(QRCVDTAQ) PARM(&DTAQN &LIBRN &LNDTA +
                          &DATA1 &WAIT1)
/** Continue GCMS Extraction                      */
             IF         COND(&DATA1 *EQ 'C') THEN(DO)
               GOTO       CMDLBL(STRTPPEXT)
             ENDDO
/** End Extraction                                */
             IF         COND(&DATA1 *EQ 'E') THEN(DO)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/** Job Termination requested by I/C Termination  */
             IF         COND(&DATA1 *EQ 'T') THEN(DO)
/**/
/** Blank Transferred ICT indicator in data area MEGCMSDA */
/*                CHGDTAARA  DTAARA(MEGCMSDA (28 1)) VALUE(' ') */ /*JMI113*/
                CHGDTAARA  DTAARA(XXGCMMDA (28 1)) VALUE(' ') /*JMI113*/
/**/
/** To indicate we are inside I/C termination and are performing */
/** a last extraction to the programs involved    */
/*              CHGDTAARA  DTAARA(MEGCMSDA (29 1)) VALUE('B') */ /*JMI113*/
                CHGDTAARA  DTAARA(XXGCMMDA (29 1)) VALUE('B') /*JMI113*/
/** Process now a last extraction                 */
               CHGVAR     VAR(&LASTEXT) VALUE('Y')
               GOTO       CMDLBL(STRTPPEXT)
             ENDDO
/** By default : continue GCMS Extraction         */
             GOTO       CMDLBL(STRTPPEXT)
/**/
 ABNOR:      ROLLBACK
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program MECJ002 ended +
                          abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) */ /*JMI113*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC113102 +
                          ended abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) +
                          /*JMI113*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDPGM:
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*           DLTOVR     FILE(MGGCMSPD)   */ /*JMI113*/
             DLTOVR     FILE(XXGCMGPD) /*JMI113*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/** Show that the job is finished                 */
/*           CHGDTAARA  DTAARA(MEGCMSDA (1 26)) VALUE(' ') */ /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMMDA (1 26)) VALUE(' ') /*JMI113*/
             ENDPGM
