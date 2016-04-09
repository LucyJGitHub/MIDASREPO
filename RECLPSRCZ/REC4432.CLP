/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE CI task monitor (background job)')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4432 - CI Task Monitor (Background Job)                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020              Date 06Aug12             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 208846             Date 29Aug02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      136943             Date 11Jun98              */
/*                      118737             Date 21May97              */
/*                      118134             Date 02Jun97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastracture     */
/*       208846 - Limit the submitted RE41220* jobs to a maximum     */
/*                of 5. Reset counter to zero in this program.       */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       136943 - Remove redundant conditioning to ensure Cashier    */
/*                batch jobs submitted when required                 */
/*       118737 - Make interface start-up crash-proof.               */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface.                                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)   VALUE('       ')
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)   VALUE('*FIRST ')
             DCL        VAR(&BAII)   TYPE(*CHAR) LEN(800)
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(1)                                */ /*CCB020*/
/**********  DCL        VAR(&FUINIT) TYPE(*CHAR) LEN(1)                                */ /*CCB020*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)
 
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/
/* Get System Prefix and concat to DPLIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *TCAT 'DPLIB')
 
/**/
/*  Check if REC4432 has already been submitted, ie, no dtaara has yet been */
/*  created.  */
/**/
             CRTDTAARA  DTAARA(&DPLIB/REC4432) TYPE(*CHAR) LEN(1) +
                          VALUE(*) TEXT('CI Task Monitor Data Area')
/************MONMSG*****MSGID(CPF1023) EXEC(DO)*/                     /*118737*/
             MONMSG     MSGID(CPF1023)                                /*118737*/
                                                                      /*118737*/
/* Attempt to allocate the data area. If it is already locked, then   /*118737*/
/* the task monitor is already active.                                /*118737*/
                                                                      /*118737*/
             ALCOBJ     OBJ((&DPLIB/REC4432  *DTAARA *EXCL)) +
                          WAIT(1)                                     /*118737*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                       /*118737*/
                                                                      /*118737*/
               SNDPGMMSG  MSG('Cashier Interface Task Monitor is already  +
                          active')  TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             CHGJOB     SWS(00000000)
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
 
             RTVJOBA  JOB(&JOB) USER(&USR) NBR(&NBR)
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
             CALL       PGM(AOBAIIR0) PARM(&RTCD &OPTN &BAII)
             IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ABNOR))
 
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)         */ /*136943*/
/**********  CHGVAR     VAR(&FUINIT) VALUE(%SST(&BAII 47 1))       */ /*136943*/
/**********  IF COND((&FUINIT *EQ 'Y')*AND(&MPHAS *EQ 'F'))THEN(DO)*/ /*136943*/
/**********    CALL     PGM(RE4436) PARM('I' &JOB &USR &NBR)       */ /*136943*/
/**********    CALL     PGM(RE4432)                                */ /*136943*/
/**********  ENDDO                                                 */ /*136943*/
/**********                                                        */ /*136943*/
/**********  IF COND((&FUINIT *EQ 'N')*AND(&MPHAS *EQ 'A'))THEN(DO)*/ /*136943*/
/**********    ALCOBJ   OBJ((REC4432 *PGM *EXCL)) WAIT(5)          */ /*136943*/
/**********    MONMSG   MSGID(CPF1002) EXEC(DO)                    */ /*136943*/
/**********      SNDPGMMSG  MSG('CI Task Monitor is already active.') +*136943*/
/**********                   TOMSGQ(MOPERQ MRUNQ)                 */ /*136943*/
/**********      CHGJOB     SWS(XXXXXX11)                          */ /*136943*/
/**********      DLCOBJ     OBJ((REC4432 *PGM *EXCL))              */ /*136943*/
/**********      GOTO       CMDLBL(END)                            */ /*136943*/
/**********    ENDDO                                               */ /*136943*/
                                                                                          /*208846*/
/* Reset the RE41220* counters to zero */                                                 /*208846*/
                                                                                          /*208846*/
               CHGDTAARA  DTAARA(RE41220JE) VALUE(000)                                    /*208846*/
               CHGDTAARA  DTAARA(RE41220JF) VALUE(000)                                    /*208846*/
               CHGDTAARA  DTAARA(RE412200E) VALUE(000)                                    /*208846*/
               CHGDTAARA  DTAARA(RE412200F) VALUE(000)                                    /*208846*/
                                                                                          /*208846*/
               CALL     PGM(RE4436) PARM('I' &JOB &USR &NBR)
               CALL     PGM(RE4432)
/**********    DLCOBJ   OBJ((REC4432 *PGM *EXCL))                  */ /*136943*/
/**********  ENDDO                                                 */ /*136943*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               ROLLBACK
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                 TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             ELSE (GOTO CMDLBL(END))
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Task Monitor (Background job) Program Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG  MSGID(CPF2469)  EXEC(DO)                         /*118134*/
                SNDPGMMSG  MSG('CI Task Monitor (Background job) Program Ended +
                             Abnormally') TOMSGQ(QSYSOPR)             /*118134*/
             ENDDO                                                    /*118134*/
             MONMSG     MSGID(CPF0000)                                /*136943*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CALL     PGM(RE4436) PARM('D' &JOB &USR &NBR)
             MONMSG   MSGID(CPF0000)                                  /*118134*/
             ENDCMTCTL
             MONMSG   MSGID(CPF0000)                                  /*118134*/
/**/
/***Delete*dtaara*REC4432***/                                         /*136943*/
/**/
/************DLTDTAARA  DTAARA(&DPLIB/REC4432) */                     /*118737*/
/************MONMSG     MSGID(CPF2105)         */                     /*118737*/
/**/                                                                  /*136943*/
/* Deallocate the data area REC4432                                   /*136943*/
/**/                                                                  /*136943*/
             DLCOBJ     OBJ((REC4432 *DTAARA *EXCL))                  /*136943*/
             MONMSG     MSGID(CPF0000)                                /*136943*/
 
ENDPGM:      ENDPGM
