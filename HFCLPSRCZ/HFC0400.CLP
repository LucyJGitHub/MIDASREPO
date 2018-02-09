/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Input cycle extract')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - History and Audit Facility Module               */
/*                                                                   */
/*       HFC0400  - INPUT CYCLE EXTRACT                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG7286            Date 23May05              */
/*                      CSC020             Date 31Mar04              */
/*                      223027             DATE 13Nov03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      099430             DATE 09JUL96              */
/*                      085993             DATE 06JUN95              */
/*                      081777             DATE 05JUN95              */
/*                      S01379             DATE 17SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       223027 - Increase format field for AOHAFDR0 to 200 bytes.   */
/*       099430 - If a HAF Item has been deleted, ignore the item    */
/*                when doing the extract, to prevent abnormal end.   */
/*       085993 - Hafmonitor submitted twice due to slow exec. of AS */
/*                (ICI and SIGNON submit.)                           */
/*       081777 - Wait time not observed if no journal entries       */
/*                are extracted.                                     */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(HFFILEPD)
 
             DCL        VAR(&JNSEQ) TYPE(*DEC) LEN(10 0) VALUE(1)
             DCL        VAR(&JNSEQX) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&FIRST) TYPE(*DEC) LEN(1 0) VALUE(0)      /*081777*/
             DCL        VAR(&FIRST) TYPE(*CHAR) LEN(1) VALUE(N)       /*081777*/
             DCL        VAR(&X) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&Y) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&XOLD) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&WAITN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&WAIT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&STOPREQ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CHGOLD) TYPE(*CHAR) LEN(13)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
/************DCL********VAR(&FMT) TYPE(*CHAR) LEN(19)***************************************223027*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*223027*/
             DCL        VAR(&JRCV) TYPE(*CHAR) LEN(10)                                   /*BUG7286*/
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*                                                                                          CSC020*/
/*  Determine journal sequence number of next day set up.                                   CSC020*/
/*  (Equivalent to beginning of ICRCV001 in previous releases)                              CSC020*/
/*                                                                                          CSC020*/
/************SCRTVJEVT  EVENT(NDSUJR) SEQ(&JNSEQ)                                 *CSC020**BUG7286*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&JRCV) SEQ(&JNSEQ)                        /*BUG7286*/
/*                                                                                          CSC020*/
/*  If no value returned, then set sequence to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&JNSEQ *EQ 0) THEN(DO)                                       /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNSEQNBR(&JNSEQ)                                               /*CSC020*/
             ENDDO                                                                        /*CSC020*/
             CHGVAR     VAR(&JNSEQX) VALUE(&JNSEQ)                                        /*CSC020*/
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
 
/* */
/* Allocate the data area HFLOCK. If this is locked program is */
/* already active and therefore this program should terminate */
/* */
/*********** ALCOBJ     OBJ((HFLOCK *DTAARA *EXCL)) */                /*085993*/
             ALCOBJ     OBJ((HFLOCK *DTAARA *EXCL)) WAIT(0)           /*085993*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(END))
 
/* Get wait time from HAF ICD */                                      /*081777*/
                                                                      /*081777*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')                    /*081777*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*081777*/
             CALL       PGM(AOHAFDR0) PARM(&RTCD &OPTN &FMT)          /*081777*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*081777*/
             CHGVAR     VAR(&WAIT) VALUE(%SST(&FMT 11 3))             /*081777*/
             CHGVAR     VAR(&WAITN) VALUE(&WAIT)                      /*081777*/
             MONMSG     MSGID(CPF0000)                                /*081777*/
             ENDDO                                                    /*081777*/
 
 
/* */
/* Delete and recreate the data area JTNBAT in QTEMP which will */
/* contain the last used journal sequence number */
/* */
             DLTDTAARA  DTAARA(QTEMP/JRNBAT)
             MONMSG     MSGID(CPF0000)
/************CRTDTAARA  DTAARA(QTEMP/JRNBAT) TYPE(*CHAR) LEN(10) +                          CSC020*/
/*************************VALUE('0000000000') TEXT('Last used +                             CSC020*/
/*************************journal sequence number')                                         CSC020*/
             CRTDTAARA  DTAARA(QTEMP/JRNBAT) TYPE(*CHAR) LEN(10) +
                          VALUE(&JNSEQX) TEXT('Last used +
                          journal sequence number')                                       /*CSC020*/
 
 
/* */
/* Delete and recreate the data area JTNBATO in QTEMP which will */
/* contain the journal sequence number of the last time the */
/* program ran */
/* */
             DLTDTAARA  DTAARA(QTEMP/JRNBATO)
             MONMSG     MSGID(CPF0000)
/************CRTDTAARA  DTAARA(QTEMP/JRNBATO) TYPE(*CHAR) LEN(10) +                         CSC020*/
/************************ VALUE('0000000000') TEXT('Penultimate jrn +                       CSC020*/
/*************************seq number')                                                      CSC020*/
             CRTDTAARA  DTAARA(QTEMP/JRNBATO) TYPE(*CHAR) LEN(10) +
                          VALUE(&JNSEQX) TEXT('Penultimate jrn +
                          seq number')                                                    /*CSC020*/
 
 
/* */
/* Delete and recreate the data area JTNMOD in QTEMP which will */
/* contain the run mode */
/* */
             DLTDTAARA  DTAARA(QTEMP/JRNMOD)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/JRNMOD) TYPE(*CHAR) LEN(6) +
                          VALUE('IPCBAT') TEXT('Mode of run')
 
 
/* */
/* Delete and recreate the data area JRN2 in QTEMP which will */
/* be used by other programs */
/* */
             DLTDTAARA  DTAARA(QTEMP/JRN2)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/JRN2) TYPE(*CHAR) LEN(256)
 
/* */
/* Read all records on file */
/* */
 LOOP:       RCVF
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(SUITE))
 
/* */
/* Only process selected files */
/* */
/************IF         COND(&HEADER *NE '0') THEN(GOTO CMDLBL(LOOP))   099430*/
 
/*  Ignore deleted items. If an item is deleted, &HFJOB will            099430*/
/*   contain the name of the job which deleted it.                      099430*/
             IF         COND(&HEADER *NE '0' *OR &HFJOB *NE ' ') +
                          THEN(GOTO CMDLBL(LOOP))                     /*099430*/
 
/* */
/* Clear members JRNBATCH in files */
/* */
             RMVM       FILE(&HFLIB/&FFILE) MBR(JRNBATCH)
             MONMSG     MSGID(CPF0000)
             ADDPFM     FILE(&HFLIB/&FFILE) MBR(JRNBATCH)
 
/* */
/* Read next record */
/* */
             GOTO       CMDLBL(LOOP)
 
SUITE:
 
 
/* */
/* If dataarea HFCOB contains STOP then this program should end */
/* */
             RTVDTAARA  DTAARA(HFCOB (1 4)) RTNVAR(&STOPREQ)
             IF         COND(&STOPREQ *EQ 'STOP') THEN(GOTO +
                          CMDLBL(END))
 
 
/* */
/* Update the contents of JRNBATO with the contents of JRNBAT */
/* */
             RTVDTAARA  DTAARA(JRNBAT (1 10)) RTNVAR(&JNSEQX)
             CHGDTAARA  DTAARA(JRNBATO (1 10)) VALUE(&JNSEQX)
 
 
/**********  IF         COND(&FIRST *EQ 0) THEN(DO) **/               /*081777*/
             IF         COND(&FIRST *EQ 'N') THEN(DO)                 /*081777*/
 
/* */
/* First time through */
                                                                      /*081777*/
/* Set variable to show that first pass has executed */               /*081777*/
                                                                      /*081777*/
             CHGVAR     VAR(&FIRST) VALUE('Y')                        /*081777*/
                                                                      /*081777*/
/* Call HFC0410 to build command string */
 
             CALL       PGM(HFC0410) PARM(&X &Y &JNSEQ &XOLD &CHGOLD)
 
/* */
/* Call QCMDEXEC to execute the string */
/* */
             CALL       PGM(QCMDEXC) PARM(&X 5000)
/**********  MONMSG   MSGID(CPF7062 CPF7054) EXEC(GOTO CMDLBL(SUITE)) /*081777*/
             MONMSG     MSGID(CPF7062 CPF7054) EXEC(GOTO +
                          CMDLBL(DELAY))                              /*081777*/
 
                                                                      /*081777*/
/***/                                                                 /*081777*/
/**Set*variable*to*show*that*first*pass*has*executed**/               /*081777*/
/***/                                                                 /*081777*/
/**********  CHGVAR     VAR(&FIRST) VALUE(1) **/                      /*081777*/
 
/* */
/* Goto end of section */
/* */
             GOTO       CMDLBL(OK)
 
             ENDDO
 
/* */
/* Get sequence number from JRNBAT */
/* */
             RTVDTAARA  DTAARA(JRNBAT (1 10)) RTNVAR(&JNSEQX)
             CHGVAR     VAR(&JNSEQ) VALUE(&JNSEQX)
             CHGVAR     VAR(&JNSEQ) VALUE(&JNSEQ + 1)
 
/* */
/* Call HFC0410 to build command string */
/* */
             CALL       PGM(HFC0410) PARM(&X &Y &JNSEQ &XOLD &CHGOLD)
 
/* */
/* Call QCMDEXEC to execute the string */
/* */
             CALL       PGM(QCMDEXC) PARM(&Y 5000)
 
             MONMSG     MSGID(CPF7062 CPF7054) EXEC(DO)
 
/* */
/* Wait if there are no more entries */
/* */
/*********** CHGVAR     VAR(&OPTN) VALUE('*FIRST')           **/      /*081777*/
/*********** CHGVAR     VAR(&RTCD) VALUE('       ')          **/      /*081777*/
/*********** CALL       PGM(AOHAFDR0) PARM(&RTCD &OPTN &FMT) **/      /*081777*/
/*********** IF         COND(&RTCD *EQ '       ') THEN(DO)   **/      /*081777*/
/*********** CHGVAR     VAR(&WAIT) VALUE(%SST(&FMT 11 3))    **/      /*081777*/
/*********** CHGVAR     VAR(&WAITN) VALUE(&WAIT)             **/      /*081777*/
/*********** MONMSG     MSGID(CPF0000)                       **/      /*081777*/
/*********** ENDDO                                           **/      /*081777*/
                                                                      /*081777*/
 DELAY:                                                               /*081777*/
                                                                      /*081777*/
             DLYJOB     DLY(&WAIT)
 
/* */
/* If HFWAIT is not initailised correctly then set default of 30 secs */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DLYJOB DLY(30))
 
/* */
/* Start all over again */
/* */
             GOTO       CMDLBL(SUITE)
 
             ENDDO
 
/* */
/* Send extracted records to the correct place */
/* */
OK:          CALL       PGM(HFC0420)
 
/* */
/* Start all over again */
/* */
             GOTO       CMDLBL(SUITE)
 
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0400 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
