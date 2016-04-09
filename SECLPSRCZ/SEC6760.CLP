/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Early redemption process matured blocks')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                       */
/*                                                                   */
/*       SEC6760 - SE Process Matured Blocks                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU017             Date 03Avr98             */
/*                      CSE007             Date 17Dec97             */
/*                      S01408             Date 10May95             */
/*                      S01496             Date 07Oct94              */
/*                      S10978             Date 29Apr93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business         */
/*       CEU017 - Securities Redenomination Euro Changes             */
/*       CSE007 - Corporate Actions                                  */
/*       S01408 - Addition of core hook SEC6760MPS                   */
/*       S01496 - Incorporation of JYSKE Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
                                                                      /*CSE007*/
             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE007*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE007*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSE007*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CSE007*/
             DCL        VAR(&CEU017) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU017*/
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
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
 
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
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
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
/* Get system ID to build JLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *TCAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC6760MPS                                          */
                                                                      /*S01408*/
 
/* Send Information Message */
             SNDPGMMSG  MSG('SEC6760 - SE PROCESS MATURED BLOCKS') +
                          TOMSGQ(MRUNQ)
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
                                                                      /*CSE007*/
/* Check if feature CSE007 is switched ON. */                         /*CSE007*/
                                                                      /*CSE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE007*/
             CHGVAR     VAR(&SAR) VALUE('CSE007')                     /*CSE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE007*/
             IF         COND(&RTCD *EQ '       ') +
                        THEN(CHGVAR VAR(&CSE007) VALUE('Y'))          /*CSE007*/
                                                                      /*CEU017*/
/* Check if feature CEU017 is switched ON. */                         /*CEU017*/
                                                                      /*CEU017*/
             CHGVAR     VAR(&SAR) VALUE('CEU017')                     /*CEU017*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU017*/
             IF         COND(&RTCD *EQ '       ') +
                        THEN(CHGVAR VAR(&CEU017) VALUE('Y'))          /*CEU017*/
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If it's a Restart */
             IF         COND(&BUSY = 'Y') THEN(DO)
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* Check Existence of the Journal Receiver */
             CHKOBJ     OBJ(JRSEC6760) OBJTYPE(*JRNRCV)
 
/* If Journal Receiver does not exist */
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
 
/* Check Existence of the Journal */
             CHKOBJ     OBJ(JSEC6760) OBJTYPE(*JRN)
 
/* If Journal does not exist */
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
 
/* Remove the Journal Changes for specified files */
             RMVJRNCHG  JRN(JSEC6760) FILE((SEBLKPPD))
             MONMSG     (CPF7042 CPF7049 CPF9801)
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                              (CEU017 *EQ 'Y')) THEN(DO)              /*CEU017*/
                                                                      /*CSE007*/
/* Remove the Journal Changes for Corporate Actions Blocked */        /*CSE007*/
/* Positions file.                                          */        /*CSE007*/
             RMVJRNCHG  JRN(JSEC6760) FILE((SECOBKPD))                /*CSE007*/
             MONMSG     (CPF7042 CPF7049 CPF9801)                     /*CSE007*/
             ENDDO                                                    /*CSE007*/
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
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of job.                                      CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((SEBLKPPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
/* If feature CSE007 is switched ON. */                               /*CCB009*/
/* or feature CEU017 is switched ON. */                               /*CCB009*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                              (CEU017 *EQ 'Y')) THEN(DO)              /*CCB009*/
                                                                      /*CCB009*/
/* Remove the Journal Changes for Corporate Actions Blocked */        /*CCB009*/
/* Positions file.                                          */        /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((SECOBKPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     (CPF7042 CPF7049 CPF9801)                     /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* End the journalling for all Physical Files in the Journal */
             ENDJRNPF   FILE(*ALL) JRN(JSEC6760)
             MONMSG     MSGID(CPF7032)
 
/* Delete the Journal */
             DLTJRN     JRN(JSEC6760)
 
/* If the Journal does not exist, delete the Journal Receiver */
NOJRN:       CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JRSEC6760)
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
NOJRNRCV:    ENDDO
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRSEC6760)
             CRTJRN     JRN(&JLIB/JSEC6760) JRNRCV(&JLIB/JRSEC6760)
             STRJRNPF   FILE(SEBLKPPD) JRN(JSEC6760) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             ENDDO                                                    /*CCB009*/
 
/* Override the File on itself */
             OVRDBF     FILE(SEBLKPPD) SHARE(*YES)
/* Process an Open Query File to Select the Records of Today */
             OPNQRYF    FILE((SEBLKPPD) (SDBANKPD)) FORMAT(SEBLKPPD +
                          SEBLKPD0) QRYSLT('(VDRECI = ''D'') *AND +
                          (BJRDNB <= VDBEDT) *AND (VDBEDT < BJDNWD)')
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                                                                      /*CSE007*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* Start journaling for Corporate Actions Blocked Positions file. */  /*CSE007*/
             STRJRNPF   FILE(SECOBKPD) JRN(JSEC6760) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                            /*CSE007*/
             ENDDO                                                    /*CCB009*/
                                                                      /*CSE007*/
/* Override the file on itself. */                                    /*CSE007*/
             OVRDBF     FILE(SECOBKPD) SHARE(*YES)                    /*CSE007*/
                                                                      /*CSE007*/
/* Process an Open Query File to select the Records of Today. */      /*CSE007*/
             OPNQRYF    FILE((SECOBKPD) (SDBANKPD)) FORMAT(SECOBKPD +
                          SECOBKD0) QRYSLT('(MURECI = ''D'') *AND +
                          (BJRDNB <= MUBEDT) *AND (MUBEDT < BJDNWD)') /*CSE007*/
                                                                      /*CSE007*/
             ENDDO                                                    /*CSE007*/
                                                                      /*CSE007*/
/* Call RPG SE6760 */
             CALL       PGM(SE6760)
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6760 ENDED ABNORMALLY FOR JOB ' *CAT +
                           &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                           *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
 /***********  SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
                SNDMSG     MSG('SE6760 ENDED ABNORMALLY FOR JOB ' *CAT +
                            &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                            *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If the job is completed normally, End the Journalling of all the files */
             CLOF       OPNID(SEBLKPPD)
             DLTOVR     FILE(SEBLKPPD)
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
             CLOF       OPNID(SECOBKPD)                               /*CSE007*/
             DLTOVR     FILE(SECOBKPD)                                /*CSE007*/
             ENDDO                                                    /*CSE007*/
                                                                      /*CSE007*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JSEC6760)
 
/*                                   Delete Journal and Journal Receiver */
             DLTJRN     JRN(JSEC6760)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JRSEC6760)
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
             GOTO ENDPGM
 
/* If the job is completed abnormally, 1. Remove all Journalled Changes */
/*                                     2. Delete Journal and Jrn Receiver */
 
 ABNOR:
             CLOF       OPNID(SEBLKPPD)
             MONMSG     (CPF0000)
             DLTOVR     FILE(SEBLKPPD)
             MONMSG     (CPF0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             RMVJRNCHG  JRN(JSEC6760) FILE((SEBLKPPD))
             MONMSG     (CPF7049)
             ENDDO                                                    /*CCB009*/
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
             CLOF       OPNID(SECOBKPD)                               /*CSE007*/
             MONMSG     (CPF0000)                                     /*CSE007*/
             DLTOVR     FILE(SECOBKPD)                                /*CSE007*/
             MONMSG     (CPF0000)                                     /*CSE007*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             RMVJRNCHG  JRN(JSEC6760) FILE((SECOBKPD))                /*CSE007*/
             MONMSG     (CPF7049)                                     /*CSE007*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CSE007*/
                                                                      /*CSE007*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JSEC6760)
             DLTJRN     JRN(JSEC6760)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JRSEC6760)
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
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
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of current job.                              CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((SEBLKPPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
/* If feature CSE007 is switched ON. */                               /*CCB009*/
/* or feature CEU017 is switched ON. */                               /*CCB009*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                              (CEU017 *EQ 'Y')) THEN(DO)              /*CCB009*/
                                                                      /*CCB009*/
/* Remove the Journal Changes for Corporate Actions Blocked */        /*CCB009*/
/* Positions file.                                          */        /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((SECOBKPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     (CPF7042 CPF7049 CPF9801)                     /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
             ENDPGM
