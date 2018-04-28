/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ER Facilities Update for Dealing')              */
/********************************************************************/
/*                                                                  */
/*             MIDAS/ABS EUROPEAN REPORTING SYSTEM                  */
/*                                                                  */
/*       ERC0530 - Facilites Update For Dealing                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      CCB009             Date 01Jun00              */
/*                      ER_R10             Date 12Apr95              */
/*                      ER0116             Date 15DEC92              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       CCB009 - Journal files throughout close of business         */
/*       ER_R10  -  EUROPEAN REPORTING UPGRADE IN R10               */
/*       ER0116  -  New Program                                     */
/*                                                                  */
/********************************************************************/
 
             PGM
 
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8) VALUE('00000000')
 
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                      CCB009*/
/* Declare job name, user and number for remove journal changes         CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
 
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
             SNDPGMMSG  MSG('ERC0530 - Facilities Update For Dealing') +
                          TOMSGQ(MRUNQ)
 
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve current job attributes.                                     CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
             ENDDO                                                    /*CCB009*/
/* Identify Library Group and if this is a restart                   */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             RTVDTAARA  DTAARA(ERSTAT (41 1)) RTNVAR(&BUSY)
 
/* If restart, then remove journalled changes                        */
 
             IF         COND(&BUSY = 'Y') THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
               CHKOBJ     OBJ(JRSEC6425) OBJTYPE(*JRNRCV)
                CHKOBJ     OBJ(JRERC0530) OBJTYPE(*JRNRCV)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
                CHKOBJ     OBJ(JERC0530) OBJTYPE(*JRN)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
/**********     RMVJRNCHG  JRN(JERC0530) FILE(FCLTYMX4) */                                /*CER001*/
                RMVJRNCHG  JRN(JERC0530) FILE(LEFCX1PD)                                   /*CER001*/
                MONMSG     (CPF7042 CPF7049)
                ENDJRNPF   FILE(*ALL) JRN(JERC0530)
                MONMSG     MSGID(CPF7032)
                DLTJRN     JRN(JERC0530)
NOJRN:          CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC0530)
                CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                              CCB009*/
/*                                                                      CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)
/*                                                                      CCB009*/
/* If data area is not blank, calculate the job name, user and number   CCB009*/
/* of the previous run of this component.                               CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10)) +
                                                                      /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6)) +
                                                                      /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the first journal entry sequence number                    CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*LAST) SEARCH(*ASCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&FINISH)                          /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&FINISH) VALUE(0)                         /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((FCLTYMX4)) FROMENT(&START) +                     /*CER001*/
             RMVJRNCHG  JRN(ICJRN) FILE((LEFCX1PD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
NOJRNRCV:       CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
             ENDDO
 
/* Create temporary Journal & Receiver                               */
 
             CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('Y')
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRERC0530)
             CRTJRN     JRN(&JLIB/JERC0530) JRNRCV(&JLIB/JRERC0530)
 
             LOOP:                                                    /*ER_R10*/
/**********  STRJRNPF   FILE(FCLTYMX4) JRN(JERC0530) + */                                 /*CER001*/
             STRJRNPF   FILE(LEFCX1PD) JRN(JERC0530) +
                          IMAGES(*BOTH)
             MONMSG     MSGID(CPF9803) EXEC(GOTO CMDLBL(LOOP))        /*ER_R10*/
             ENDDO                                                    /*CCB009*/
/* Call Facilities Update For Dealing program                        */
 
             CALL       PGM(ER0530)
 
/* UNSUCCESSFUL COMPLETION - Therefore REMOVE Journalled changes     */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve attributes of current job.                                 CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the first journal entry sequence number                    CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*LAST) SEARCH(*ASCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&FINISH)                          /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&FINISH) VALUE(0)                         /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((FCLTYMX4)) FROMENT(&START) + */                  /*CER001*/
             RMVJRNCHG  JRN(ICJRN) FILE((LEFCX1PD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/**********     RMVJRNCHG  JRN(JERC0530) FILE(FCLTYMX4) */                                /*CER001*/
                RMVJRNCHG  JRN(JERC0530) FILE(LEFCX1PD)
                MONMSG     (CPF7049)
             ENDDO                                                    /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(*ALL) JRN(JERC0530)
                DLTJRN     JRN(JERC0530)
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC0530)
                CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
 
 
                SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                             TOMSGQ(MRUNQ MOPERQ)
/* ER0530 - Abort                                                    */
                GOTO ENDPGM
             ENDDO
 
/* SUCCESSFUL COMPLETION - Therefore, delete Journal & Receiver      */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                ENDJRNPF   FILE(*ALL) JRN(JERC0530)
                DLTJRN     JERC0530
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRERC0530
                CHGJOB     INQMSGRPY(*RQD)
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* GENERAL ABORT - Remove all journalled changes                     */
 
ABNOR:       RTVDTAARA  DTAARA(ERSTAT (41 1)) RTNVAR(&BUSY)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(EXIT))
             IF         COND(&BUSY = 'Y') THEN(DO)
/************** RMVJRNCHG  JRN(JERC0530) FILE(EODPOPD HPOSTPD)          ER_R10*/
/**********     RMVJRNCHG  JRN(JERC0530) FILE(FCLTYMX4) */            /*ER_R10*/          /*CER001*/
                RMVJRNCHG  JRN(JERC0530) FILE(LEFCX1PD)                                   /*CER001*/
                MONMSG     (CPF7042 CPF7049)
                ENDJRNPF   FILE(*ALL) JRN(JERC0530)
                MONMSG     MSGID(CPF7032)
                DLTJRN     JRN(JERC0530)
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC0530)
                CHGJOB     INQMSGRPY(*RQD)
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
                MONMSG     MSGID(CPF0000)
                ENDDO
EXIT:        CHGJOB     SWS(XXXXXXX1)
 
ENDPGM:      ENDPGM
