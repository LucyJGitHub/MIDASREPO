/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE End Loan Manager interface jobs (i/c)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2011A- End Lending PC Interface Background Job (I/C)     */
/*                                                                   */
/*       Function: This program will be called during Input Cycle    */
/*                 to terminate PC interface background jobs.        */
/*                                                                   */
/*       Calls:    None.                                             */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 203561  *CREATE    Date 04Mar02              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       203561 - New component to shut down Loan Manager Interface  */
/*                jobs in input cycle                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LMSERVER &LMBRCH)
 
             DCL        VAR(&LMSERVER) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LMBRCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3) VALUE(' ')
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&P#RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DISABLED) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('LEC2011A - End Lending PC Interface +
                          Background jobs') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
 
             IF         COND(&LMSERVER *NE 'ALL') THEN(DO)
                CHGVAR     VAR(&DTAARA) VALUE('LEC2010' *CAT +
                             &LMSERVER)
                CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                             &LMSERVER)
 
/* Check the LMxxx data area to see if a the branch has been disabled    */
 
                CHGVAR     VAR(&DISABLED) VALUE('N')
                CALL       PGM(LEC2019) PARM(&LMSERVER &DISABLED)
 
                IF         COND(&DISABLED *NE 'Y') THEN(DO)
 
/* Call LEC2017 to tell Loan Manager that the Interface job has ended  ad mode */
 
                   CALL       PGM(LEC2017) PARM(&P#RTCD 'ENDI' &LMSERVER +
                                &LMBRCH)
                   IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +
                                '*SENT')) THEN(GOTO CMDLBL(ABNOR))
 
/* Update LM Branch data area with last message sent */
 
                   CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('ENDI')
                ENDDO
 
/* If data area not found, then loop round and process next branch */
 
/* Check if job is running */
 
                ALCOBJ     OBJ((&DTAARA *DTAARA *EXCL)) WAIT(0)
 
/* If data area found but locked by job, then shut down branch job */
 
                MONMSG     MSGID(CPF1002) EXEC(DO)
                   CHGDTAARA  DTAARA(&DTAARA (1 1)) VALUE('Y')
                ENDDO
 
                GOTO       CMDLBL(END)
             ENDDO
 
 LOOP:
 
/* Loop round reading PF/SDBRCHPD and setting the branch job data */
/* areas to 'Y' so that the branch jobs will shut themselves down */
 
             CALL       PGM(AOBRCHR0) PARM(&RTCD &OPTN &BRCD &FMT)
 
/* Database error handling */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
                IF         COND(&RTCD *EQ '*EOF') THEN(GOTO +
                          CMDLBL(END))
                SNDPGMMSG  MSG('Error on access to Branch Details +
                    file SDBRCHPD') TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&OPTN) VALUE('*NEXT')
             CHGVAR     VAR(&SERV) VALUE(%SST(&FMT 184 3))
             CHGVAR     VAR(&BRCD) VALUE(%SST(&FMT 1 3))
             CHGVAR     VAR(&DTAARA) VALUE('LEC2010' *CAT +
                          &SERV)
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &SERV)
 
/* Only process Loan Manager branches */
 
             IF         COND(&SERV *NE ' ') THEN(DO)
 
/* Check the LMxxx data area to see if a the branch has been disabled */
 
                CHGVAR     VAR(&DISABLED) VALUE('N')
                CALL       PGM(LEC2019) PARM(&SERV &DISABLED)
 
                IF         COND(&DISABLED *NE 'Y') THEN(DO)
 
/* Call LEC2017 to tell Loan Manager that the Interface job has ended */
 
                   CALL       PGM(LEC2017) PARM(&P#RTCD 'ENDI' &SERV &BRCD)
                   IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +
                                '*SENT')) THEN(GOTO CMDLBL(ABNOR))
 
/* Update LM Branch data area with last message sent */
 
                   CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('ENDI')
                ENDDO
             ENDDO
 
/* If data area not found, then loop round and process next branch */
 
             CHKOBJ     OBJ(&DTAARA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(LOOP))
 
/* Check if job is running */
 
             ALCOBJ     OBJ((&DTAARA *DTAARA *EXCL)) WAIT(0)
 
/* If data area found but locked by job, then shut down branch job */
 
             MONMSG     MSGID(CPF1002) EXEC(DO)
                CHGDTAARA  DTAARA(&DTAARA (1 1)) VALUE('Y')
                GOTO       CMDLBL(LOOP)
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 ABNOR:
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSG('LEC2011A - End Lending PC Interface +
                             Background Job ENDED ABNORMALLY') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSG('LEC2011A - End Lending PC Interface +
                             Background Job ENDED ABNORMALLY') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
                RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CALL       PGM(SCC0010) PARM('LEC2011A' 'ENTER' ' ')
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Normal termination */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
