/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI Trickle Feed')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4445 - CI Trickle Feed                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK009             Date 09Aug99              */
/*       Prev Amend No. 118737             Date 21May97              */
/*                      118134             Date 02Jun97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       118737 - Make interface start-up crash-proof.               */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface                                  */
/*                                                                   */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&GROUP)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC)  LEN(4)
             DCL        VAR(&TIMEO)  TYPE(*DEC)  LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC)  LEN(1) VALUE(0)
             DCL        VAR(&MULT)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&MIDAS)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JNSQ1)  TYPE(*DEC)  LEN(10)
             DCL        VAR(&JNRCN1) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)
 
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
 
             DCLF       FILE(RECITHPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/
/* Get System Prefix and concat to DPLIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *TCAT 'DPLIB')
 
/**/
/*  Check if REC4445 has already been submitted, ie, no dtaara has yet been */
/*  created.  */
/**/
             CRTDTAARA  DTAARA(&DPLIB/REC4445) TYPE(*CHAR) LEN(1) +
                          VALUE(*) TEXT('CI Trickle Feed Data Area')
/************MONMSG*****MSGID(CPF1023) EXEC(DO)                       /*118737*/
             MONMSG     MSGID(CPF1023)                                /*118737*/
                                                                      /*118737*/
/* Attempt to allocate the data area. If it is already locked, then   /*118737*/
/* the branch monitor is already active.                              /*118737*/
                                                                      /*118737*/
             ALCOBJ     OBJ((&DPLIB/REC4445   *DTAARA *EXCL)) +
                          WAIT(1)                                     /*118737*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                       /*118737*/
                                                                      /*118737*/
               SNDPGMMSG  MSG('CI Trickle Feed Program is already +
                          active') TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/**/
/*  Create dtaara LDA */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
 
/* Override msgf */
 
             CHGJOB SWS(00000000)
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)
 
             IF         COND(&MULT *EQ '  ') THEN(DO)
                CHGVAR    VAR(&MULT) VALUE('GB')
             ENDDO
 
             CHGVAR     VAR(&MIDAS) VALUE(&MULT *CAT 'MIDAS')
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDAS)
 
/* Main Processing */
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG MSGID(CPF8351)
 
/* Log in REACJBPD - Jobs File */
 
             RTVJOBA  JOB(&JOB) USER(&USR) NBR(&NBR)
             CALL     PGM(RE4436) PARM('I' &JOB &USR &NBR)
 
             OPNDBF     FILE(RECITHPD) OPTION(*INP)
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
               CLOF OPNID(RECITHPD)
               CHGJOB SWS(XXXXXX11)
               GOTO CMDLBL(DBERR)
             ENDDO
 
             CHGVAR     VAR(&JNSQ1) VALUE(&RSJOSQ + 1)
             CLOF       OPNID(RECITHPD)
 
 /* Receive certain journal entries */
 
 RCVJ:
             RCVJRNE    JRN(ICJRN) EXITPGM(RE4445) FILE((RSACMTPD) +
                          (ACCNTAB) (STOPCSD)) +
                          RCVRNG(&RSNXRC *CURRENT) FROMENT(&JNSQ1) +
                          JRNCDE(R U) ENTTYP(PT UP UR XJ XE) +
                          DELAY(1)
             MONMSG     MSGID(CPF9803) EXEC(DO)
               DLYJOB DLY(30)
               GOTO RCVJ
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
 
/* If there's a change in journal receiver - U6 is ON */
 
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
               CALL       REC4446 PARM(&JNSQ1 &JNRCN1)
               CHGVAR     VAR(&JNSQ1)  VALUE(&JNSQ1 + 1)
               CHGVAR     VAR(&RSNXRC) VALUE(&JNRCN1)
               CHGJOB     SWS(XXXXX0XX)
               GOTO RCVJ
             ENDDO
 
             GOTO       CMDLBL(END)
 
 /* Database error processing */
 
 DBERR:
             ROLLBACK
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Trickle Feed Program Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG  MSGID(CPF2469)  EXEC(DO)                         /*118134*/
                SNDPGMMSG  MSG('CI Trickle Feed Program Ended +
                             Abnormally') TOMSGQ(QSYSOPR)             /*118134*/
             ENDDO                                                    /*118134*/
 
 END:
             CALL     PGM(RE4436) PARM('D' &JOB &USR &NBR)
             MONMSG   MSGID(CPF0000)                                  /*118134*/
             ENDCMTCTL
             MONMSG   MSGID(CPF0000)                                  /*118134*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/*  Delete dtaara REC4445  */
/**/
/************DLTDTAARA  DTAARA(&DPLIB/REC4445)                          118737*/
/************MONMSG     MSGID(CPF2105)                                  118737*/
 
 ENDPGM:
             ENDPGM
