/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG SD interface for customers')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC0023  - SD interface for customer details.               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CAP034             Date 21Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      086505             Date 19Apr95              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       CAP034 - Midas / ToF Interface SDCUSD                       */
/*       086505 - Suppress display of prompt screen                  */
/*       S01522 - User Defined Coorespondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &ACTN &CUSTNO)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CUSTNO) TYPE(*CHAR) LEN(6) /*Customer no*/
             DCL        VAR(&CPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&YORN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INTBATCH) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&P2PARM) TYPE(*CHAR) LEN(57)                                  /*CGL029*/
             DCL        VAR(&P2PARM) TYPE(*CHAR) LEN(69)                                  /*CGL029*/
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CAP134) TYPE(*CHAR) LEN(1)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches & remove messages */
/* */
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTCD) VALUE(' ')
 
/* If action code is NOT a deletion check for S01531 being switched on  */
 
             IF         COND(&ACTN *NE 'D') THEN(DO)
             CHGVAR     VAR(&RETURN) VALUE('       ')
             CHGVAR     VAR(&OPTION) VALUE('*VERIFY')
             CHGVAR     VAR(&SARNBR) VALUE('S01531')
 
             CALL       PGM(AOSARDR0) PARM(&RETURN &OPTION &SARNBR &SARFMT)
             IF         COND(&RETURN *NE '       ') THEN(DO)
                GOTO ENDCLPGM
             ENDDO
             ENDDO
 
/* If action code is a deletion check for CAP134 being switched on     *CAP034*/
 
             IF         COND(&ACTN *EQ 'D') THEN(DO)                  /*CAP034*/
             CHGVAR     VAR(&RETURN) VALUE('       ')                 /*CAP034*/
             CHGVAR     VAR(&OPTION) VALUE('*VERIFY')                 /*CAP034*/
             CHGVAR     VAR(&SARNBR) VALUE('CAP134')                  /*CAP034*/
             CHGVAR     VAR(&CAP134) VALUE(' ')                       /*CAP034*/
 
             CALL       PGM(AOSARDR0) PARM(&RETURN &OPTION &SARNBR &SARFMT)   /*CAP034*/
             IF         COND(&RETURN *NE '       ') THEN(DO)          /*CAP034*/
             CHGVAR     VAR(&CAP134) VALUE('N')                       /*CAP034*/
             ENDDO                                                    /*CAP034*/
             ELSE       (DO)                                          /*CAP034*/
             CHGVAR     VAR(&CAP134) VALUE('Y')                       /*CAP034*/
             ENDDO                                                    /*CAP034*/
             ENDDO                                                    /*CAP034*/
 
/* */
/* Retrieve TYPE to determine if the job is being run interactively(1) */
/* or in batch.                                                        */
/* */
             RTVJOBA    TYPE(&INTBATCH)
/************IF         COND(&INTBATCH *EQ '1') THEN(DO)               *CAP034*/
/************CHGVAR     VAR(&CPGM) VALUE('SD0011R')                    *CAP034*/
/************ENDDO                                                     *CAP034*/
 
             IF         COND(&INTBATCH *EQ '1') THEN(DO)              /*CAP034*/
 
             IF         COND(&CAP134 *EQ 'Y') THEN(DO)                /*CAP034*/
             CHGVAR     VAR(&CPGM) VALUE('SDCUSDRTV')                 /*CAP034*/
             ENDDO                                                    /*CAP034*/
             ELSE       (DO)                                          /*CAP034*/
             CHGVAR     VAR(&CPGM) VALUE('SD0011R')                   /*CAP034*/
             ENDDO                                                    /*CAP034*/
 
             ENDDO
             ELSE       (DO)
 
             IF         COND(&CAP134 *EQ 'Y') THEN(DO)                /*CAP034*/
             CHGVAR     VAR(&CPGM) VALUE('SDCUSDRTV')                 /*CAP034*/
             ENDDO                                                    /*CAP034*/
             ELSE       (DO)                                          /*CAP034*/
             CHGVAR     VAR(&CPGM) VALUE('CGC0023')
             ENDDO
             ENDDO
 
             IF         COND(&ACTN *EQ 'D') THEN(DO)
             CALL       PGM(CG0120) PARM(&RTCD &CUSTNO &CPGM)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
 
             IF         COND(&ACTN *NE 'D') THEN(DO)
/* */                                                                 /*086505*/
/* Remove prompt screen as already in Customer details */             /*086505*/
/* */                                                                 /*086505*/
/************                                                          *086505*/
/************CALL       PGM(CG0025) PARM(&RTCD &YORN)                  *086505*/
/************                                                          *086505*/
/**Check*for*Database errors trapped by program *                      *086505*/
/************                                                          *086505*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)               *086505*/
/************RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)             *086505*/
/************SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +     *086505*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                  *086505*/
/************GOTO       CMDLBL(ABNORMAL)                               *086505*/
/************ENDDO                                                     *086505*/
/************                                                          *086505*/
/************IF         COND(&RTCD *EQ 'Y2U9999' *OR &RTCD *EQ +       *086505*/
/************             USR0790) THEN(DO)                            *086505*/
/************GOTO       CMDLBL(ENDCLPGM)                               *086505*/
/************ENDDO                                                     *086505*/
/************                                                          *086505*/
/************IF         COND(&RTCD *NE ' ') THEN(DO)                   *086505*/
/************GOTO       CMDLBL(ABNORMAL)                               *086505*/
/************ENDDO                                                     *086505*/
             CHGVAR     VAR(&YORN) VALUE('Y')                         /*086505*/
 
             IF         COND(&YORN *EQ 'Y') THEN(DO)
             IF         COND(&ACTN *EQ 'I' *OR &ACTN *EQ 'A') THEN(DO)
             CHGVAR     VAR(&ACTN) VALUE('a')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&ACTN) VALUE('e')
             ENDDO
/* */
/* Substring the customer number into the correct position of the  */
/* &P2PARM parameter.                                              */
/* */
             CHGVAR     VAR(%SST(&P2PARM 11 6))  VALUE(&CUSTNO)
/**********  CHGVAR     VAR(%SST(&P2PARM 50 4))  VALUE('CUST')                            /*CGL029*/
             CHGVAR     VAR(%SST(&P2PARM 62 4))  VALUE('CUST')                            /*CGL029*/
 
             CALL       PGM(CG0020) PARM(&RTCD &ACTN &P2PARM)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
             ENDDO
 
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0023 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0023 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 
             ENDPGM
