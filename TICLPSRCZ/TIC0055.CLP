/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Check Midas/TI background jobs have ended')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0055 - End the Midas Background Jobs on request and at   */
/*                 the begninning of close of business.              */
/*                                                                   */
/*       Called by CoB and Menu Option 'TIBT - End Batch Processing' */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG4969            Date 29Nov04              */
/*       Prev Amend No. CTI004             Date 12Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      173478             Date 19Jan00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      162541 *CREATE     Date 13Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG4969 - If background jobs have ended for any reason we   */
/*                 still want extra call to pick up final postings.  */
/*       CTI004 - Midas Plus-TI Integration Enhancements             */
/*                Defalut Profit Centre from Matrix                  */
/*       173478 - Only end commitment control if it was activated    */
/*                by this job.                                       */
/*       162541 - Eliminate the need to check Input cycle status all */
/*                day, by ending the batch processing at beginning of*/
/*                COB.                                               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(17)
             DCL        VAR(&TEX2) TYPE(*CHAR) LEN(17)
             DCL        VAR(&BATCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&STSCDE) TYPE(*CHAR) LEN(1) VALUE('S')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NUMBER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&NUMBE2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)                       /*173478*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&TRFLAG) TYPE(*CHAR) LEN(1)                                   /*CTI004*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('TIC0055 - Ending Background TI Batch +
                           jobs') TOMSGQ(MRUNQ)
 
/* Attempt to allocate data areas which are locked by the jobs       */
/* TIJRNENT and TISHDPST.                                            */
 
TIJRNENT:
 
/* Determine if the job is still running */
 
             ALCOBJ     OBJ((TIJRNENT *DTAARA *EXCL)) WAIT(5)
                MONMSG     MSGID(CPF1002) EXEC(DO)
 
/* Retrieve job information  */
 
             RTVDTAARA  DTAARA(TI0340 (7 17)) RTNVAR(&TEXT)
 
             CHGVAR     VAR(&USER) VALUE(%SST(&TEXT 1 10))
             CHGVAR     VAR(&NUMBER) VALUE(%SST(&TEXT 12 6))
 
/* End the journal entry job */
 
             ENDJOB     JOB(&NUMBER/&USER/TIJRNENT) OPTION(*IMMED)
                MONMSG     MSGID(CPF1321) EXEC(DO)
                GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO                                                                       /*BUG4969*/
                                                                                         /*BUG4969*/
/* Call the Batch program with Status Code = 'S', to process the last */
/* postings */
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
 /********** MONMSG     MSGID(CPF8351)  ***************************           /*173478*/
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                          VALUE('Y'))
                                                                              /*173478*/
/* Check Transaction Flag To Indicate Valid TRTOT Field                                   /*CTI004*/
             RTVDTAARA  DTAARA(TIDTA (32 1)) RTNVAR(&TRFLAG)                              /*CTI004*/
             IF         COND(&TRFLAG *EQ 'Y') THEN(DO)                                    /*CTI004*/
                CALL       PGM(TI0341) PARM(&STSCDE &BATCH)                               /*CTI004*/
             ENDDO                                                                        /*CTI004*/
             ELSE       CMD(DO)                                                           /*CTI004*/
             CALL       PGM(TI0340) PARM(&STSCDE &BATCH)
             ENDDO                                                                        /*CTI004*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                 GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*  END OF PROCESSING FOR TIJRNENT JOB  */
 
             IF         COND(&CMTCTL *NE 'Y') THEN(DO)                        /*173478*/
             ENDCMTCTL
             MONMSG     MSGID(CPF8350)
             ENDDO                                                            /*173478*/
 
/************ENDDO                                                                    */ /*BUG4969*/
TISHDPST:
 
/* Determine if the job is still running */
 
             ALCOBJ     OBJ((TISHDPST *DTAARA *EXCL)) WAIT(5)
                MONMSG     MSGID(CPF1002) EXEC(DO)
 
             RTVDTAARA  DTAARA(TI0350 (7 17)) RTNVAR(&TEX2)
 
             CHGVAR     VAR(&USE2) VALUE(%SST(&TEX2 1 10))
             CHGVAR     VAR(&NUMBE2) VALUE(%SST(&TEX2 12 6))
 
             ENDJOB     JOB(&NUMBE2/&USE2/TISHDPST) OPTION(*IMMED)
                MONMSG     MSGID(CPF1321) EXEC(DO)
                GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO                                                                       /*BUG4969*/
                                                                                         /*BUG4969*/
/* Create the last projected postings for today's processing */
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
 /********** MONMSG     MSGID(CPF8351)  ***************************           /*173478*/
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                          VALUE('Y'))                                         /*173478*/
 
             CALL       PGM(TI0350) PARM(&RTNCDE)
             IF         COND(&RTNCDE *EQ 'E') THEN(GOTO CMDLBL(ABNOR))
             IF         COND(&RTNCDE *EQ 'S') THEN(GOTO CMDLBL(END))
 
             IF         COND(&CMTCTL *NE 'Y') THEN(DO)                        /*173478*/
             ENDCMTCTL
             MONMSG     MSGID(CPF8350)
             ENDDO                                                            /*173478*/
 
/************ENDDO                                                                    */ /*BUG4969*/
 
/* Normal ending */
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination  */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             CHGVAR     VAR(&MSG) VALUE('TIC0055 - Check Midas/TI +
                          background jobs terminated abnormally')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
                                                                                         /*BUG4969*/
/* If ALCOBJ was successful, relese now AS TIC034* calls from this program have          /*BUG4969*/
/* already ended. This allows TIC0050 to reallocate for background calls.                /*BUG4969*/
             DLCOBJ     OBJ((TIJRNENT *DTAARA *EXCL))                                    /*BUG4969*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                /*BUG4969*/
                                                                                         /*BUG4969*/
             DLCOBJ     OBJ((TISHDPST *DTAARA *EXCL))                                    /*BUG4969*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                /*BUG4969*/
                                                                                         /*BUG4969*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
