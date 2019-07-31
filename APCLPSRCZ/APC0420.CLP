/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AP Confirmations Job')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APC0420   - Transaction Validate and Update                 */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. AR566732           Date 12Apr18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      AR925993           Date 13Jul16              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG21873           Date 08Jan09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG6752            Date 13May05              */
/*                      BUG4451            Date 05Oct04              */
/*                      BUG2791            Date 19May04              */
/*                      BUG2692            Date 18May04              */
/*                      BUG2381 *CREATE    Date 13May04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR566732 - Confirmation for Lending transaction not produce.*/
/*                  Change condition to also check LE Module is      */
/*                  switched on, then produce confo on job LEC0212A. */
/*                - Applied for MD-50255.                            */
/*       MD046248 - Finastra Rebranding                              */
/*       AR925993 - Rollover rate fixing does not produce            */
/*                  confirmation. APCONFS will submit LEC3165 if     */
/*                  an update will trigger on file CLOANCL.          */
/*                  (Child: AR925994)                                */
/*                - Applied for MD039397.                            */
/*       BUG21873 - Multiple APCONFS on MSGW.                        */
/*       BUG6752 - &PPARM is not set for calling DLC1921.            */
/*       BUG4451 - Parameter mismatch when calling LEC0213           */
/*       BUG2791 - Batch submit of confirmations programs. Extension */
/*                 of fix BUG2692 for SE module.                     */
/*       BUG2692 - Batch submit of confirmations programs. Extension */
/*                 of fix BUG2692 for FT and DL Rate Fixing.         */
/*       BUG2381 - Batch submit of confirmations programs            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,APC0420INT                                          */
 
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DTAQ1) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(10)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSGDATA1) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(256)                                /*BUG2791*/
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&WAIT1) TYPE(*DEC) LEN(5 0) VALUE(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(*BLANKS)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OPTN1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&VAL) TYPE(*CHAR) LEN(200)
             DCL        VAR(&VAL1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PENT) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&PPARM) TYPE(*CHAR) LEN(100)                              */ /*BUG6752*/
             DCL        VAR(&PPARM) TYPE(*CHAR) LEN(100) VALUE(*BLANKS)                  /*BUG6752*/
             DCL        VAR(&NEXSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARMSTRING) TYPE(*CHAR) LEN(101)
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3) VALUE('ALL')
             DCL        VAR(&DISTR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PPGMRPG) TYPE(*CHAR) LEN(10) VALUE('DL0308')
             DCL        VAR(&PPGMCL) TYPE(*CHAR) LEN(10) VALUE('DLC0211')
             DCL        VAR(&PCSEQ) TYPE(*CHAR) LEN(5) VALUE('10001')
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(5) VALUE('S')
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(*BLANKS)
             DCL        VAR(&OPIN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7) VALUE(*BLANKS)                   /*BUG2692*/
 
             DCLF       FILE(SDMGMEPD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**********  ALCOBJ     OBJ((APCONF *DTAARA *EXCL))                  */                 /*BUG21873*/
/**********  MONMSG     MSGID(CPF0000)                               */                 /*BUG21873*/
             ALCOBJ     OBJ((APCONF *DTAARA *EXCLRD)) WAIT(5)                           /*BUG21873*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)                         /*BUG21873*/
                GOTO       CMDLBL(END)                                                  /*BUG21873*/
             ENDDO       /*BUG21873*/
             CHGJOB     SWS(XXXXXX00)
 
/* Create LDA */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
/* Check Midas Modules installed */
 
             RTVJOBA    JOB(&JOB)
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             RCVF       RCDFMT(SDMGMED0)
 
/* Check system value for Confirmation Job Cycle Time */
 
             CHGVAR     VAR(&RTCD) VALUE(*BLANKS)
             CHGVAR     VAR(&OPTN) VALUE('ConfmJobCycleTime')
             CHGVAR     VAR(&VAL) VALUE(*BLANKS)
 
             CALL       PGM(AOSVALR0) PARM(&RTCD &OPTN &VAL &OPTN1 &VAL1 +
                          &OPTN1 &VAL1 &OPTN1 &VAL1 &OPTN1 &VAL1 &OPTN1 +
                          &VAL1 &OPTN1 &VAL1 &OPTN1 &VAL1 &OPTN1 &VAL1 +
                          &OPTN1 &VAL1)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
             DMPCLPGM
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&WAIT) VALUE(&VAL))
 
/* Set up call to QRCVDTAQ */
 
             CHGVAR     VAR(&DTAQ) VALUE('APCONFDTQ   ')
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')
 START:
 
/* If cycle time is 0, do not submit any jobs */
 
             IF         COND(&VAL *EQ '0') THEN(DO)
             CHGVAR     VAR(&WAIT) VALUE(99999)
             GOTO       CMDLBL(DLY)
             ENDDO
 
/* LENDING MODULE */
 
/*********   IF         COND((%SST(&MMOD 28 1) *EQ 'Y') *OR  +   */                     /*AR566732*/
/*********                 (%SST(&MMOD 36 1) *EQ 'Y')) THEN(DO)  */                     /*AR566732*/
/**/                                                                                    /*AR566732*/
/** Also check lending module is switch on  */                                          /*AR566732*/
/**/                                                                                    /*AR566732*/
             IF         COND((%SST(&MMOD 28 1) *EQ 'Y') *OR  +
                             (%SST(&MMOD 36 1) *EQ 'Y') *OR +
                             (%SST(&MMOD 10 1) *EQ 'Y')) THEN(DO)                       /*AR566732*/
 
/* Receive DTAQ APLECNFDQ if LTRIX file for LE had changed */
 
             CHGVAR     VAR(&DTAQ1) VALUE('APLECNFDQ   ')
             CHGVAR     VAR(&MSGDATA1) VALUE('          ')
             CALL       PGM(QRCVDTAQ) PARM(&DTAQ1 &DTAQLIBL +
                          &MSGLENGTH &MSGDATA1 &WAIT1)
             IF         COND(%SST(&MSGDATA1 1 6) *NE 'LECONF') THEN(DO)
             GOTO       CMDLBL(LEEND)
             ENDDO
 
/* Clear LE Confirmation job Data Queue */
 
             CALL       PGM(QCLRDTAQ) PARM(&DTAQ1 &DTAQLIBL)
 
/* Check for Pay/Receive job being active */
 
             RTVDTAARA  DTAARA(LESTAT)  RTNVAR(&LESTAT)
 
             IF         COND(%SST(&LESTAT 7 1) *EQ 'N') THEN(DO)
/* Submit Confirmations to jobq if OK */
             SNDPGMMSG  MSG('MIDAS LE CONFIRMATION JOB') TOMSGQ(MSTATUS)
 
             ALCOBJ     OBJ((LECONF *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(DLY))
             SBMJOB     JOB(LEC0212A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   LEC0212A') +
                          INLLIBL(*JOBD) MSGQ(*NONE)
 
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(*NONE)
             DLCOBJ     OBJ((LECONF *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
             ENDDO
 
/* Submit Pay/Receive generation jobs */
             SNDPGMMSG  MSG('MIDAS LE PAY/RECEIVE JOB') TOMSGQ(MSTATUS)
 
             SBMJOB     JOB(LEC0213) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   LEC0213 +
                          (''     '' '' '' ''   '')') INLLIBL(*JOBD) +
                          MSGQ(*NONE)                                                    /*BUG4451*/
/**********               RTGDTA(*JOBD) RQSDTA('CALL   LEC0213') +
                          INLLIBL(*JOBD) MSGQ(*NONE)                                  */ /*BUG4451*/
 
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(*NONE)
 
/**********LEEND:      ENDDO                                         */                 /*AR925993*/
                                                                                        /*AR925993*/
 LEEND:                                                                                 /*AR925993*/
                                                                                        /*AR925993*/
/* LENDING RATE FIXING */                                                               /*AR925993*/
                                                                                        /*AR925993*/
/* Receive DTAQ APLERTFDQ if CLOANCL file for LE had changed */                         /*AR925993*/
                                                                                        /*AR925993*/
             CHGVAR     VAR(&DTAQ1) VALUE('APLERTFDQ   ')                               /*AR925993*/
             CHGVAR     VAR(&MSGDATA1) VALUE('          ')                              /*AR925993*/
             CALL       PGM(QRCVDTAQ) PARM(&DTAQ1 &DTAQLIBL +
                          &MSGLENGTH &MSGDATA1 &WAIT1)                                  /*AR925993*/
             IF         COND(%SST(&MSGDATA1 1 8) *NE 'LERTCONF') THEN(DO)               /*AR925993*/
             GOTO       CMDLBL(LERTEND)                                                 /*AR925993*/
             ENDDO       /*AR925993*/
                                                                                        /*AR925993*/
/* Clear LE Confirmation job Data Queue */                                              /*AR925993*/
                                                                                        /*AR925993*/
             CALL       PGM(QCLRDTAQ) PARM(&DTAQ1 &DTAQLIBL)                            /*AR925993*/
                                                                                        /*AR925993*/
/* Submit Rate Fixing generation jobs */                                                /*AR925993*/
             ALCOBJ     OBJ((LEC3165 *PGM *EXCL)) WAIT(1)                               /*AR925993*/
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(GOTO CMDLBL(END))                   /*AR925993*/
             DLCOBJ     OBJ((LEC3165 *PGM *EXCL))                                       /*AR925993*/
                                                                                        /*AR925993*/
             SNDPGMMSG  MSG('MIDAS LE RATE FIX JOB') TOMSGQ(MSTATUS)                    /*AR925993*/
                                                                                        /*AR925993*/
             SBMJOB     JOB(LEC3165) JOBD(MBATCH) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          LEC3165 PARM(''I'' ''YES'')') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                   /*AR925993*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)                        /*AR925993*/
                                                                                        /*AR925993*/
 LERTEND:    ENDDO       /*AR925993*/
 
 
/* DEALING MODULE */
 
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
 
/* Receive DTAQ APDLCNFDQ if DTRIXDD file for DL had changed */
 
             CHGVAR     VAR(&DTAQ1) VALUE('APDLCNFDQ   ')
             CHGVAR     VAR(&MSGDATA1) VALUE('          ')
             CALL       PGM(QRCVDTAQ) PARM(&DTAQ1 &DTAQLIBL +
                          &MSGLENGTH &MSGDATA1 &WAIT1)
             IF         COND(%SST(&MSGDATA1 1 6) *NE 'DLCONF') THEN(DO)
             GOTO       CMDLBL(DLEND)
             ENDDO
 
/* Clear DL Confirmation job Data Queue */
 
             CALL       PGM(QCLRDTAQ) PARM(&DTAQ1 &DTAQLIBL)
 
/* Check for Pay/Receive job being active */
 
             RTVDTAARA  DTAARA(DLSTAT)  RTNVAR(&DLSTAT)
 
             IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
/* Submit Confirmations to jobq if OK */
             SNDPGMMSG  MSG('MIDAS DL CONFIRMATION JOB') TOMSGQ(MSTATUS)
 
             SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)
             ENDDO
 
/* Submit Pay/Receive generation jobs */
             IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
 
/* Simulate FCC0202 processing */
 
             SNDPGMMSG  MSG('MIDAS DL PAY/RECEIVE JOB') TOMSGQ(MSTATUS)
             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(%SST(&PARMSTRING 1 100)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&PARMSTRING 101 1)) VALUE('@')
             RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&NEXSEQ)
 
             CALL       PGM(FC1000) PARM(&PRTCD &NEXSEQ  &PPGMRPG +
                        &PPGMCL &PCSEQ &LEVEL &ENTITY &OPIN)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             SBMJOB     CMD(CALL PGM(FCC0200) PARM(&PPGMCL &NEXSEQ +
                          &LEVEL &ENTITY &PARMSTRING &PPGMRPG &PCSEQ)) +
                          JOB(DLC0211) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(MOPERQ)
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)
             ENDDO
 
 DLEND:
 
/* DEALING RATE FIXING */
 
/* Receive DTAQ APDLRTFDQ if DTRIXDD file for DL had changed */
 
             CHGVAR     VAR(&DTAQ1) VALUE('APDLRTFDQ   ')
             CHGVAR     VAR(&MSGDATA1) VALUE('          ')
             CALL       PGM(QRCVDTAQ) PARM(&DTAQ1 &DTAQLIBL +
                          &MSGLENGTH &MSGDATA1 &WAIT1)
             IF         COND(%SST(&MSGDATA1 1 8) *NE 'DLRTCONF') THEN(DO)
             GOTO       CMDLBL(DLRTEND)
             ENDDO
 
/* Clear DL Confirmation job Data Queue */
 
             CALL       PGM(QCLRDTAQ) PARM(&DTAQ1 &DTAQLIBL)
 
/* Submit Pay/Receive for Rate Fixing generation jobs */
             ALCOBJ     OBJ((DLC1921 *PGM *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(GOTO CMDLBL(END))
             DLCOBJ     OBJ((DLC1921 *PGM *EXCL))
 
             SNDPGMMSG  MSG('MIDAS DL RATE FIX PAY/RECEIVE JOB') TOMSGQ(MSTATUS)
 
             CHGVAR     VAR(%SST(&PPARM 1 1)) VALUE('0')                                 /*BUG6752*/
             SBMJOB     CMD(CALL PGM(DLC1921) PARM(&PSEQ &PLEV &PENT +
                          &PPARM)) JOB(DLC1921) JOBD(MBATCH) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)
 
             SBMJOB     JOB(MIDASMRV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)
 
 DLRTEND:    ENDDO
 
/* FUNDS TRANSFER */
 
             IF         COND(%SST(&MMOD 57 1) *EQ 'Y') THEN(DO)                          /*BUG2692*/
                                                                                         /*BUG2692*/
/* Receive DTAQ APFTCNFDQ if OTPAYDD/CQPACDD/NTRANDD had changed */                      /*BUG2692*/
                                                                                         /*BUG2692*/
             CHGVAR     VAR(&DTAQ1) VALUE('APFTCNFDQ   ')                                /*BUG2692*/
             CHGVAR     VAR(&MSGDATA1) VALUE('          ')                               /*BUG2692*/
             CALL       PGM(QRCVDTAQ) PARM(&DTAQ1 &DTAQLIBL +
                          &MSGLENGTH &MSGDATA1 &WAIT1)                                   /*BUG2692*/
             IF         COND(%SST(&MSGDATA1 1 6) *NE 'FTCONF') THEN(DO)                  /*BUG2692*/
             GOTO       CMDLBL(FTEND)                                                    /*BUG2692*/
             ENDDO       /*BUG2692*/
                                                                                         /*BUG2692*/
/* Clear FT Confirmation job Data Queue */                                               /*BUG2692*/
                                                                                         /*BUG2692*/
             CALL       PGM(QCLRDTAQ) PARM(&DTAQ1 &DTAQLIBL)                             /*BUG2692*/
                                                                                         /*BUG2692*/
/* Prequalify FT record before submitting the job */                                     /*BUG2692*/
                                                                                         /*BUG2692*/
             CALL       PGM(APFTPGM) PARM(&RETURN)                                       /*BUG2692*/
                                                                                         /*BUG2692*/
             IF         COND(&RETURN *EQ '*ERROR ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                 /*BUG2692*/
             IF         COND(&RETURN *EQ '*NO    ') THEN(GOTO +
                          CMDLBL(FTEND))                                                 /*BUG2692*/
                                                                                         /*BUG2692*/
/* Submit Pay/Receive for Pay/Receive generation jobs */                                 /*BUG2692*/
                                                                                         /*BUG2692*/
             IF         COND(&RETURN *EQ '*YES   ') THEN(DO)                             /*BUG2692*/
             SNDPGMMSG  MSG('MIDAS FT PAY/RECEIVE JOB') TOMSGQ(MSTATUS)                  /*BUG2692*/
                                                                                         /*BUG2692*/
             SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +
                          PARM('''' '''' '''' )') INLLIBL(*JOBD)                         /*BUG2692*/
                                                                                         /*BUG2692*/
             SBMJOB     JOB(MIDASMRV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                        /*BUG2692*/
             ENDDO       /*BUG2692*/
                                                                                         /*BUG2692*/
 FTEND:      ENDDO       /*BUG2692*/
                                                                                         /*BUG2692*/
/* SECURITIES MODULE */                                                                  /*BUG2791*/
 
             IF         COND(%SST(&MMOD 30 1) *EQ 'Y') THEN(DO)                          /*BUG2791*/
                                                                                         /*BUG2791*/
/* Receive DTAQ APSECNFDQ if trade and depo movement had changed */                      /*BUG2791*/
                                                                                         /*BUG2791*/
             CHGVAR     VAR(&DTAQ1) VALUE('APSECNFDQ   ')                                /*BUG2791*/
             CHGVAR     VAR(&MSGDATA1) VALUE('          ')                               /*BUG2791*/
             CALL       PGM(QRCVDTAQ) PARM(&DTAQ1 &DTAQLIBL +
                          &MSGLENGTH &MSGDATA1 &WAIT1)                                   /*BUG2791*/
             IF         COND(%SST(&MSGDATA1 1 6) *NE 'SECONF') THEN(DO)                  /*BUG2791*/
             GOTO       CMDLBL(SEEND)                                                    /*BUG2692*/
             ENDDO       /*BUG2791*/
 
/* Clear SE Confirmation job Data Queue */                                               /*BUG2791*/
                                                                                         /*BUG2791*/
             CALL       PGM(QCLRDTAQ) PARM(&DTAQ1 &DTAQLIBL)                             /*BUG2791*/
                                                                                         /*BUG2791*/
             RTVDTAARA  DTAARA(SESTAT)  RTNVAR(&SESTAT)                                  /*BUG2791*/
 
             IF         COND(%SST(&SESTAT 73 1) *EQ 'N') THEN(DO)                        /*BUG2791*/
/* Submit Confirmation generation job */                                                 /*BUG2791*/
                                                                                         /*BUG2791*/
             SNDPGMMSG  MSG('MIDAS SE CONFIRMATION JOB') TOMSGQ(MSTATUS)                 /*BUG2791*/
                                                                                         /*BUG2791*/
             SBMJOB     JOB(SEC0304) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                    /*BUG2791*/
                                                                                         /*BUG2791*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                    /*BUG2791*/
             ENDDO       /*BUG2791*/
                                                                                         /*BUG2791*/
 SEEND:      ENDDO       /*BUG2791*/
                                                                                         /*BUG2791*/
 DLY:
 
/* Receive DTAQ APCONFDTQ delaying for 30 minutes */
 
             CALL       PGM(QRCVDTAQ) PARM(&DTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &WAIT)
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
             GOTO       CMDLBL(START)
 
 ABNOR:
/*/COPY WNCPYSRC,APC0420ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          APC0420 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 END:
/**********  DLCOBJ     OBJ((APCONF *DTAARA *EXCL))                  */                 /*BUG21873*/
             DLCOBJ     OBJ((APCONF *DTAARA *EXCLRD))                                   /*BUG21873*/
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,APC0420END                                          */
 
             ENDPGM
